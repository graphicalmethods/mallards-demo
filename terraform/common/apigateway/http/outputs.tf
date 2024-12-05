output "apigateway_base_uri" {
    description = "The base URI of the API Gateway Endpoint"
    value = aws_apigatewayv2_api.api_gateway.api_endpoint
}

output "apigateway_stage_uri" {
    description = "The stage URI of the API Gateway Endpoint"
    value = aws_apigatewayv2_stage.apigateway_stage.invoke_url
}