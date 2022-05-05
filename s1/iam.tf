#Administrators IAM Group
resource "aws_iam_group" "administrators" {
  name = "administrators"
}

#Attach BackUpFullAccess policy to admin IAM Group
resource "aws_iam_group_policy_attachment" "aws_config_attach" {
  group      = aws_iam_group.administrators.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBackupFullAccess"
}

#IAM Role for Backup
resource "aws_iam_role" "backup_selection" {
  name = "backupselection"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "backup.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    tag-key = "BackUp_Selection"
  }
}
