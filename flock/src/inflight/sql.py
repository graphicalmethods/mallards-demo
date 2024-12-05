from sqlglot import parse_one, exp, transpile
from sqlglot.optimizer.scope import build_scope, Scope
from sqlglot.optimizer.qualify_columns import qualify_columns
from sqlglot.errors import ParseError
from typing import Optional
import json

class SQLParsing():
    def __init__(self):
        pass

    def ___validate_query(self, query: str) -> list[str]:
        """Validates the query as type duckdb.

        Args:
            query (str): SQL query to be validated.

        Returns:
            list[str]: Returns the validated query.
        """
        try:
            query = transpile(query, read="duckdb", write="duckdb")
        except ParseError as e:
            return json.dumps(str(e))

        return query

    def __build_scope(self, query: str) -> Optional[Scope]:
        """Creates a sqlglot Scope object from the query.

        Args:
            query (str): A validated SQL query.

        Returns:
            Optional[Scope]: A sglglot Scope object.
        """
        ast = parse_one(query)
        ast = qualify_columns(ast, None)
        root = build_scope(ast)

        return root

    def parse_sql_stmnt(self, query:str) -> dict[str, list[str]]:
        """Parses the SQL query into a dictionary of tables and columns.

        Args:
            query (str): A sql query to be parsed.

        Returns:
            dict[str, list[str]]: Dictionary of tables as keys and list of columns.
        """
        query = self.___validate_query(query)
        root = self.__build_scope(query[0])

        if root is not None:
            tables = {}
            for scope in root.traverse():
                for alias, (node, source) in scope.selected_sources.items():
                    if isinstance(source, exp.Table):
                        tables[source.name] = []
                    for c in scope.columns:
                        if isinstance(scope.sources.get(c.table), exp.Table):
                            tables[source.name].append(c.name)
        else:
            raise ValueError('query must have a from statement')

        return tables
