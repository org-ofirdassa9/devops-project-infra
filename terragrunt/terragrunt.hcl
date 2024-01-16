locals {
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  aws_region   = local.region_vars.locals.aws_region
}

remote_state {
    backend = "s3"
    generate = {
        path = "state.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket = "terraform-${local.aws_region}-hms"
        profile = "default"
        key = "terraform/${path_relative_to_include()}/terraform.tfstate"
        region = "${local.aws_region}"
        encrypt = true
        dynamodb_table = "terraform-state-locks"
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"

    contents = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  profile = "default"
}
EOF
}