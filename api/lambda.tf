
# █░░ ▄▀█ █▀▄▀█ █▄▄ █▀▄ ▄▀█   █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ 
# █▄▄ █▀█ █░▀░█ █▄█ █▄▀ █▀█   █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ 

# Foo Endpoint Handler
resource "aws_lambda_function" "foo_handler" {
  function_name = local.lambda_fn_name
  role          = aws_iam_role.lambda_exec.arn
  architectures = [ "x86_64" ]

  # Network
  vpc_config {
    security_group_ids = [ data.aws_security_group.default.id ]
    subnet_ids         = [ 
      data.aws_subnet.app_a.id,
      data.aws_subnet.app_b.id,
      data.aws_subnet.app_c.id
    ]
  }
  replace_security_groups_on_destroy = true

  # Runtime Environment
  runtime = "python3.13"
  handler = "lambda.lambda_handler"

  # Deployment Artefact
  filename         = data.archive_file.lambda_py.output_path
  source_code_hash = data.archive_file.lambda_py.output_base64sha256
}

# Email Reminder Artefact
data "archive_file" "lambda_py" {
  type = "zip"
  source_file = "files/lambda.py"
  output_path = "files/lambda.zip"
}

# API Gateway Invoke Permission
resource "aws_lambda_permission" "api_gw" {
  function_name = aws_lambda_function.foo_handler.function_name
  statement_id  = "AllowInvocationFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("", [
    "arn:aws:execute-api:us-east-1:",
    data.aws_caller_identity.current.account_id, ":",
    aws_api_gateway_rest_api.this.id, "/*/",
    aws_api_gateway_method.foo_get.http_method,
    aws_api_gateway_resource.foo.path
  ])
}

