output "iam_role_arn" {
    description = "The lambda role arn"
    value =  aws_iam_role.iam_for_lambda.arn
}