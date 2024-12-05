variable "function_name" {
    description = "The lambda function name"
    default = "dev-i-used-the-default"
    type = string
}

variable "role_arn" {
    description = "The lambda role arn"
    default = "arn:aws:iam::123456789012:role/USEDTHEDEFAULT"
    type = string
}

variable "architectures" {
    description = "The lambada architecture to use"
    default = ["x86_64"]
    type = list(string)
}

variable "image_uri" {
    description = "The ECR image URI"
    default = "123456789012.dkr.ecr.us-east-2.amazonaws.com/dev-i-used-the-default"
    type = string
}

variable "memory_size" {
    description = "Lambda memory size"
    default = 128
    type = number
}

variable "ephemeral_storage_size" {
    description = "value"
    default = 512
    type = number
}

variable "reserved_concurrent_executions" {
    description = "The reserved concurrent executions"
    default = -1
    type = number
}

variable "timeout" {
    description = "Amount of time lambda can run in seconds"
    default = 3
    type = number
}

variable "tags" {
    description = "Tags"
    default = {Environment = "dev", Name = "serverless-duckdb"}
    type = map
}

variable "ecr_repo_name" {
    description = "ECR Repo name"
    default = "dev-i-used-the-default"
    type = string
}