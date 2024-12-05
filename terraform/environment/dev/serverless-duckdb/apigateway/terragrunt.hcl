locals {
	common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

	env = local.common_vars.locals.env
}

include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "${get_path_to_repo_root()}/terraform/common/apigateway/http"
}

dependency "lambda" {
    config_path = "../lambda"
    mock_outputs_allowed_terraform_commands = ["plan"]
    mock_outputs = {
        lambda_invoke_arn = "arn:aws:lambda:us-east-2:123456789012:function:my-function:1"
        lambda_function_name = "serverless-duckdb"
    }
}

inputs = {
    apigateway_name = "${local.env}-serverless-duckdb"
    apigateway_description = "API Gateway for serverless-duckdb"
    apigateway_integration_description = "API Gateway integration for serverless-duckdb"
    aws_lambda_invoke_arn = dependency.lambda.outputs.lambda_invoke_arn
    lambda_function_name = dependency.lambda.outputs.lambda_function_name
    apigateway_integration_method = "POST"
    apigateway_route = "POST /query"
    apigateway_stage_name = "${local.env}"
    apigateway_auto_deploy = true
    apigateway_stage_description = "API gateway stage for ${local.env}-serverless-duckdb"
}