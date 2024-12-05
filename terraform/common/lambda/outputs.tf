output "lambda_invoke_arn" {
    description = "The lambda invoke arn used in API Gateway"
    value = aws_lambda_function.aws_lambda_function.invoke_arn
}

output "lambda_function_name" {
    description = "The lambda function name"
    value = aws_lambda_function.aws_lambda_function.function_name
}