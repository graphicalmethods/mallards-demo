locals {
	common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

	env = local.common_vars.locals.env
}

include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "${get_path_to_repo_root()}/terraform/common/ecr"
}

inputs = {
    ecr_repo_name = "${local.env}-serverless-duckdb"
    ecr_repo_tags = {Environment = "${local.env}", Name = "${local.env}-serverless-duckdb-demo"}
    lamda_directory = "${get_repo_root()}/lambda"
    lambda_docker_command = "make aws-ecr-publish"
}