
# █▀▀ █░░ █▀█ █░█ █▀▄ █░█░█ ▄▀█ ▀█▀ █▀▀ █░█ 
# █▄▄ █▄▄ █▄█ █▄█ █▄▀ ▀▄▀▄▀ █▀█ ░█░ █▄▄ █▀█ 

resource "aws_cloudwatch_log_group" "lambda_foo" {
  name              = "/aws/lambda/${ local.lambda_fn_name }"
  retention_in_days = 14
}

