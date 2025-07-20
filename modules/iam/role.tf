resource "aws_iam_role" "iac" {
  name = "iac"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AssumeByRoot"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::519501010528:root"
        }
      },
      {
        Sid    = "AssumeByAdmin"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::519501010528:user/admin"
        }
      },
      {
        Sid    = "AssumeBySpacelift"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "324880187172"
        },
        Condition = {
          StringLike = {
            "sts:ExternalId" = "kryptoblack@*"
          }
        },
      },
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "iac_admin" {
  role       = aws_iam_role.iac.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
