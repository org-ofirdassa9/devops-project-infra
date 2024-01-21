resource "aws_iam_role" "grafana" {
  assume_role_policy = data.aws_iam_policy_document.grafana_assume_role_policy.json
  name               = "role-${var.cluster_name}-grafana"
}

resource "aws_iam_policy" "grafana" {
  policy = file("./cloudwatch-grafana.json")
  name   = "policy-${var.cluster_name}-grafana"
}

resource "aws_iam_role_policy_attachment" "grafana" {
  role       = aws_iam_role.grafana.name
  policy_arn = aws_iam_policy.grafana.arn
}
