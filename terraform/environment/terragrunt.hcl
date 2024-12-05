locals {
	provider_vars = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
	backend_vars = read_terragrunt_config(find_in_parent_folders("backend.hcl"))

	profile_name = local.provider_vars.locals.profile_name
	aws_region = local.provider_vars.locals.aws_region

	state_bucket = local.backend_vars.locals.state_bucket
	dynamodb_table = local.backend_vars.locals.state_bucket
}

# Generate an AWS provider block
generate "provider" {
	path = "provider.tf"
	if_exists = "overwrite_terragrunt"
	contents = <<EOF
provider "aws" {
	region = "${local.aws_region}"
	profile = "${local.profile_name}"
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
	backend = "s3"
	config = {
		encrypt	= true
		bucket = local.state_bucket
		key = "${path_relative_to_include()}/terraform.tfstate"
		region = local.aws_region
		dynamodb_table = local.dynamodb_table
	}
	generate = {
		path = "backend.tf"
		if_exists = "overwrite_terragrunt"
	}
}