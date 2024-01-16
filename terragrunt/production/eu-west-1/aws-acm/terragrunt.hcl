terraform {
    source = "../../../../tf-modules/aws-acm"
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}

inputs =  {
  domain_name = "example.com"
}