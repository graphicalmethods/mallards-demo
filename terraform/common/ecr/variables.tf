variable "ecr_repo_name" {
    description = "The ECR repository name"
    default = "serverless-duckdb"
    type = string
}

variable "ecr_repo_tags" {
    description = "Tags to apply to the ECR repo"
    default = {Environment = "dev", Name = "serverless-duckdb"}
    type = map
}

variable "lamda_directory" {
    description = "The lambda function directory"
    default = ""
    type = string
}

variable "lambda_docker_command" {
    description = "The make command to build and push the lambda image"
    default = ""
    type = string
}
