terraform {
    source = "../../../../tf-modules/github-actions"
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}

inputs =  {
  subjects = ["org-ofirdassa9/devops-project-client:*", "org-ofirdassa9/devops-project-server:*"]
}