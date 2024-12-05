output "aws_ecr_repository_uri" {
    description = "AWS ECR repository uri"
    value = aws_ecr_repository.aws_ecr_repository.repository_url
}
