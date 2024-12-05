# mallards

Example invocation. Change ```https://<lambda_url>.amazonaws.com/query``` for your lambda url.

```bash
# API Command
curl --header "Content-Type: application/json" --request POST --data '{"query_string": "select count(*) as total from \"dev-quack-data-lake.demo\""}' https://<lambda_url>.amazonaws.com/query | jq '.total[]'
```

Example .env

```bash
export IMAGE=goose
export ECR_NAME=dev-serverless-duckdb
export PLATFORM_NAME=linux_amd64_gcc4
export RELEASE_VERSION_NUMBER=0.9.2
export AWS_REGION=
export AWS_ACCOUNT_ID=
export AWS_PROFILE=
export LAMBDA_HANDLER_NAME=mallard.handler
```