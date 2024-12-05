locals {
	common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))

	env = local.common_vars.locals.env
}

include "root" {
    path = find_in_parent_folders()
}

terraform {
    source = "${get_path_to_repo_root()}/terraform/common/roles/serverless-duckdb"
}

inputs = {
    iam_role_name = "${local.env}-serverless-duckdb-role"
    lambda_policy_name = "${local.env}-serverless-duckdb-policy"
    lambda_policy_description = "${local.env}-serverless-duckdb policy"
}