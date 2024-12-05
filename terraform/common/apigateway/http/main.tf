resource "aws_apigatewayv2_api" "api_gateway" {
	name = var.apigateway_name
	protocol_type = "HTTP"
	description = var.apigateway_description
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  	api_id = aws_apigatewayv2_api.api_gateway.id
  	integration_type = "AWS_PROXY"
	payload_format_version = "2.0"

  	connection_type = "INTERNET"
  	description = var.apigateway_integration_description
  	integration_method = var.apigateway_integration_method
  	integration_uri = var.aws_lambda_invoke_arn
}

resource "aws_apigatewayv2_stage" "apigateway_stage" {
	api_id = aws_apigatewayv2_api.api_gateway.id
	name = var.apigateway_stage_name
	auto_deploy = var.apigateway_auto_deploy
	description = var.apigateway_stage_description
}

resource "aws_apigatewayv2_route" "apigateway_route" {
	api_id = aws_apigatewayv2_api.api_gateway.id
	route_key = var.apigateway_route
	target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*"
}
