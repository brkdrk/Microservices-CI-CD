resource "aws_iam_policy" "brkdrk_policy_for_master_role" {
  name        = "brkdrk_policy_for_master_role"
  policy      = file("./modules/IAM/brkdrk_policy_for_master.json")
}

resource "aws_iam_policy" "brkdrk_policy_for_worker_role" {
  name        = "brkdrk_policy_for_worker_role"
  policy      = file("./modules/IAM/brkdrk_policy_for_worker.json")
}

resource "aws_iam_role" "brkdrk_role_for_master" {
  name = "brkdrk_role_master_k8s"

  # Terraform "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "brkdrk_role_for_master"
  }
}

resource "aws_iam_role" "brkdrk_role_for_worker" {
  name = "brkdrk_role_worker_k8s"

  # Terraform "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "brkdrk_role_for_worker"
  }
}

resource "aws_iam_policy_attachment" "attach_for_master" {
  name       = "attachment_for_master"
  roles      = [aws_iam_role.brkdrk_role_for_master.name]
  policy_arn = aws_iam_policy.brkdrk_policy_for_master_role.arn
}

resource "aws_iam_policy_attachment" "attach_for_worker" {
  name       = "attachment_for_worker"
  roles      = [aws_iam_role.brkdrk_role_for_worker.name]
  policy_arn = aws_iam_policy.brkdrk_policy_for_worker_role.arn
}

resource "aws_iam_instance_profile" "brkdrk_profile_for_master" {
  name  = "brkdrk_profile_for_master"
  role = aws_iam_role.brkdrk_role_for_master.name
}

resource "aws_iam_instance_profile" "brkdrk_profile_for_worker" {
  name  = "brkdrk_profile_for_worker"
  role = aws_iam_role.brkdrk_role_for_worker.name
}

output master_profile_name {
  value       = aws_iam_instance_profile.brkdrk_profile_for_master.name
}

output worker_profile_name {
  value       = aws_iam_instance_profile.brkdrk_profile_for_worker.name
}