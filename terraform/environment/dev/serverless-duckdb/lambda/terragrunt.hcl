locals {
	common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

	env = local.common_vars.locals.env
}

include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "${get_path_to_repo_root()}/terraform/common/lambda"
}

dependency "ecr" {
    config_path = "../ecr"
    mock_outputs_allowed_terraform_commands = ["plan"]
    mock_outputs = {
        aws_ecr_repository_uri = "123456789012.dkr.ecr.us-east-2.amazonaws.com/dev-i-used-the-default"
    }
}

dependency "policy" {
    config_path = "../policies"
    mock_outputs_allowed_terraform_commands = ["plan"]
    mock_outputs = {
        iam_role_arn = "arn:aws:iam::123456789012:role/USEDTHEDEFAULT"
    }
}

inputs = {
    # Function inputs
    function_name = "${local.env}-serverless-duckdb"
    role_arn = dependency.policy.outputs.iam_role_arn
    ecr_repo_name = split("/", dependency.ecr.outputs.aws_ecr_repository_uri)[1]
    memory_size = 3008
    ephemeral_storage_size = 512
    timeout = 60
    tags = {Environment = "${local.env}", Name = "${local.env}-serverless-duckdb-demo"}
}
