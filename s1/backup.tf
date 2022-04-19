resource "aws_backup_plan" "db_backups" {
  name = "db_backups"

  rule {
    rule_name         = "backup_rule_db"
    target_vault_name = aws_backup_vault.db_backup_vault.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      delete_after = 14
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
}


resource "aws_backup_vault" "db_backup_vault" {
  name        = "example_backup_vault"
}

resource "aws_backup_selection" "db_backup" {
  iam_role_arn = aws_iam_role.backup_selection.arn
  name         = "backup_selection_db"
  plan_id      = aws_backup_plan.db_backups.id

  resources = [
    aws_db_instance.database.arn
  ]
}
