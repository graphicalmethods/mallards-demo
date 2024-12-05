import duckdb
import json
from inflight.sql import SQLParsing

class queryDuck():
    def __init__(self, region:str, db_location:str = '/tmp/disk.db', **kwargs) -> None:
        """Loads the duckdb extensions

        Args:
            region (str): On disk db location for allowing spilling to disk. Defaults to '/tmp/disk.db'.
            db_location (str, optional): On disk db location for allowing spilling to disk. Defaults to '/tmp/disk.db'.
             **kwargs: Used to pass in an aws credentials.
        """
        self.con = duckdb.connect(db_location)
        self.con.execute("SET extension_directory='/tmp';")
        self.con.execute("INSTALL httpfs;")
        self.con.execute("LOAD httpfs;")
        self.con.execute(f"SET s3_region = '{region}';")

        self.__s3_profile = kwargs.get('s3_profile', False)
        self.__aws_credentials = kwargs.get('aws_credentials', False)

        if self.__s3_profile:
            self.con.execute("INSTALL aws;")
            self.con.execute("LOAD aws;")
            self.con.execute(f"CALL load_aws_credentials({self.__s3_profile});")
        elif self.__aws_credentials:
            s3_access_key_id, s3_secret_access_key, s3_session_token = self.__aws_credentials.values()
            self.con.execute(f"SET s3_access_key_id = '{s3_access_key_id}';")
            self.con.execute(f"SET s3_secret_access_key = '{s3_secret_access_key}';")
            self.con.execute(f"SET s3_session_token = '{s3_session_token}';")
        else:
            self.con.execute("INSTALL aws;")
            self.con.execute("LOAD aws;")
            self.con.execute("CALL load_aws_credentials();")

    def parse_query(self, query:str) -> dict[str, list[str]]:
        """Parses the SQL query into a dictionary of tables and columns.

        Args:
            query (str): A sql query string.

        Returns:
            dict[str, list[str]]: A dictionary of tables as keys and list of columns.
        """
        parsing = SQLParsing()
        parsed_sql = parsing.parse_sql_stmnt(query)
        return parsed_sql

    def add_tables(self, query:str) -> None:
        """Adds the parquet files in s3 as views to the duckdb database.

        Args:
            query (str): A sql query string.
        """
        parsed_sql = self.parse_query(query)
        s3_locations = [(f"s3://{loc.replace('.', '/')}/*.parquet", loc) for loc in parsed_sql.keys()]

        for location, loc in s3_locations:
            self.con.read_parquet(location).create_view(loc)

    def execute(self, query:str) -> str:
        """Adds the parquet files in s3 as views to the duckdb database, executes the query, and 
        returns the results as a json object.

        Args:
            query (str): A sql query string.

        Returns:
            str: A json object containing the results of the query.
        """
        self.add_tables(query)
        self.cur = self.con.cursor()

        try:
            results = self.cur.execute(query)
            results = results.arrow().to_pydict()
        except duckdb.Error as e:
            return json.dumps(str(e), default=str)

        return json.dumps(results, default=str)
