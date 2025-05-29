
# █ █▀▄ █▀▀ █▄░█ ▀█▀ █ ▀█▀ █▄█   ▄▀█ █▀▀ █▀▀ █▀▀ █▀ █▀   █▀▄▀█ ▄▀█ █▄░█ ▄▀█ █▀▀ █▀▀ █▀▄▀█ █▀▀ █▄░█ ▀█▀ 
# █ █▄▀ ██▄ █░▀█ ░█░ █ ░█░ ░█░   █▀█ █▄▄ █▄▄ ██▄ ▄█ ▄█   █░▀░█ █▀█ █░▀█ █▀█ █▄█ ██▄ █░▀░█ ██▄ █░▀█ ░█░ 

# Lambda Execution Role
resource "aws_iam_role" "lambda_exec" {
  name               = "ServerlessPilotFoo_LambdaExecutionRole"
  assume_role_policy = file("json/lambda-trust-policy.json")
}

# Inline CloudWatch Logs Policy
resource "aws_iam_role_policy" "cloudwatch_logs" {
  name   = "ServerlessPilotFoo_CloudWatchLogs"
  role   = aws_iam_role.lambda_exec.id
  policy = templatefile("json/lambda-exec-policy.json", {
    log_group_arn = aws_cloudwatch_log_group.lambda_foo.arn
  })
}

