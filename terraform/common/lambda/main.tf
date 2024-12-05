data "aws_ecr_image" "lambda_image" {
	repository_name = var.ecr_repo_name
	image_tag = "latest"
}

resource "aws_lambda_function" "aws_lambda_function" {
    function_name = var.function_name
    role = var.role_arn

    architectures = var.architectures
    image_uri = data.aws_ecr_image.lambda_image.image_uri

    memory_size = var.memory_size
    ephemeral_storage {
        size = var.ephemeral_storage_size
    }

    logging_config {
        application_log_level = "INFO"
        system_log_level = "INFO"
        log_format = "JSON"
    }

    package_type = "Image"
    reserved_concurrent_executions = var.reserved_concurrent_executions 
    timeout = var.timeout
    tags = var.tags
}
