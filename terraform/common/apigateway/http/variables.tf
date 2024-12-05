variable "apigateway_name" {
    description = "The API Gateway name"
    default = "serverless-duckdb"
    type = string
}

variable "apigateway_description" {
    description = "API Gateway description"
    default = "API Gateway for serverless-duckdb"
    type = string
}

variable "apigateway_integration_description" {
    description = "API Gateway integration description"
    default = "API Gateway integration for serverless-duckdb"
    type = string
}

variable "aws_lambda_invoke_arn" {
    description = "Lambda invoke arn for API Gateway Integration"
    default = "arn:aws:lambda:us-east-2:123456789012:function:my-function:1"
    type = string
}

variable "apigateway_integration_method" {
    description = "The HTTP Method"
    default = "POST"
    type = string
}

variable "apigateway_route" {
    description = "The API Gateway route"
    default = "$default"
    type = string
}

variable "apigateway_stage_name" {
    description = "The API Gateway stage name"
    default = "dev-serverless-duckdb"
    type = string
}

variable "apigateway_auto_deploy" {
    description = "Auto deploy the stage"
    default = false
    type = bool
}

variable "apigateway_stage_description" {
    description = "The API Gateway stage description"
    default = "API gateway stage for serverless-duckdb"
    type = string
}

variable "lambda_function_name" {
    description = "The lambda function name to call"
    default = "serverless-duckdb"
    type = string
}