variable "iam_role_name" {
    description = "The IAM role name"
    default = "dev-i-used-the-default"
    type = string
}

variable "lambda_policy_name" {
    description = "The lambda policy name"
    default = "dev-i-used-the-default"
    type = string
}

variable "lambda_policy_description" {
    description = "Description of lambda policy"
    default = "The default lambda policy"
    type = string
}