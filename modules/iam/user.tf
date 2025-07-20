resource "aws_iam_user" "admin" {
  name = "admin"
  tags = var.common_tags
}
