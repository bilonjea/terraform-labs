data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name = "${local.name_prefix}-lambda-${var.resource_suffix}"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Name = "${local.name_prefix}-lambda-role-${var.resource_suffix}"
  }
}

resource "aws_lambda_function" "web" {
  function_name = "${local.name_prefix}-web-${var.resource_suffix}"

  role = aws_iam_role.lambda.arn

  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  timeout     = 10
  memory_size = 128

  tags = {
    Name = "${local.name_prefix}-lambda-web-${var.resource_suffix}"
  }
}

resource "aws_lambda_function_url" "web" {
  function_name      = aws_lambda_function.web.function_name
  authorization_type = "NONE"
}