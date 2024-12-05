import json
import os
from inflight.query import queryDuck

def handler(event, context):

    # Set region for duckdb connection
    REGION=os.getenv('AWS_REGION')

    # Used for local testing
    if event.get('aws_credentials', False):
        aws_credentials = {
            's3_access_key_id' : os.getenv('AWS_ACCESS_KEY_ID'),
            's3_secret_access_key' : os.getenv('AWS_SECRET_ACCESS_KEY'),
            's3_session_token': os.getenv('AWS_SESSION_TOKEN')
        }
    else:
        aws_credentials = None

    body = json.loads(event.get('body', False))

    if body:
        q = queryDuck(region=REGION, aws_credentials=aws_credentials)

        query_results = q.execute(body.get("query_string"))
    else:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "error": "No query string provided"
            })
        }

    response = {
        "statusCode": 200,
        "body": query_results
    }
    return response
