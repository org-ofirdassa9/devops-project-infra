resource "aws_iam_role" "gh_actions" {
  assume_role_policy = data.aws_iam_policy_document.gh_actions_assume_role_policy.json
  name               = "role-github-actions"
}

resource "aws_iam_policy" "ecr_push" {
  policy = file("./ecr-push.json")
  name   = "policy-github-actions-ecr-push"
}

resource "aws_iam_role_policy_attachment" "gh_actions" {
  role       = aws_iam_role.gh_actions.name
  policy_arn = aws_iam_policy.ecr_push.arn
}

module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
}