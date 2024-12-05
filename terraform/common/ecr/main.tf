resource "aws_ecr_repository" "aws_ecr_repository" {
	name = var.ecr_repo_name
	image_tag_mutability = "MUTABLE"
	force_delete = true

	image_scanning_configuration {
		scan_on_push = true
	}

	tags = var.ecr_repo_tags

	provisioner "local-exec" {
		command = var.lambda_docker_command
		working_dir = var.lamda_directory
	}
}
