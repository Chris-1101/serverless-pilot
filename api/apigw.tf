
# ▄▀█ █▀█ █   █▀▀ ▄▀█ ▀█▀ █▀▀ █░█░█ ▄▀█ █▄█ 
# █▀█ █▀▀ █   █▄█ █▀█ ░█░ ██▄ ▀▄▀▄▀ █▀█ ░█░ 

# API Gateway REST API
resource "aws_api_gateway_rest_api" "this" {
  name        = "serverless-pilot"
  description = "Backend API for the serverless pilot project"

  endpoint_configuration {
    types           = [ "REGIONAL" ]
    ip_address_type = "ipv4"
  }
}

# Version 1 Stage
resource "aws_api_gateway_stage" "v1" {
  stage_name    = "v1"
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.initial.id

  lifecycle {
    ignore_changes = [ deployment_id ]
  }
}

# Initial Deployment
resource "aws_api_gateway_deployment" "initial" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  description = "Initial production deployment"

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --- /foo endpoint

# API Gateway Resource /foo
resource "aws_api_gateway_resource" "foo" {
  path_part   = "foo"
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
}

# --- OPTIONS

# OPTIONS /foo
resource "aws_api_gateway_method" "foo_options" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.foo.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# OPTIONS /foo 200 Response
resource "aws_api_gateway_method_response" "foo_options_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.foo.id
  http_method = aws_api_gateway_method.foo_options.http_method
  status_code = "200"

  # Response Headers
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false   # false = optional
    "method.response.header.Access-Control-Allow-Methods" = false   # true = required
    "method.response.header.Access-Control-Allow-Origin"  = false   # Enables CORS
  }

  # Response Body
  response_models = {
    "application/json" = "Empty"
  }
}

# OPTIONS /foo Integration
resource "aws_api_gateway_integration" "foo_options" {
  rest_api_id          = aws_api_gateway_rest_api.this.id
  resource_id          = aws_api_gateway_resource.foo.id
  http_method          = aws_api_gateway_method.foo_options.http_method
  type                 = "MOCK"
  timeout_milliseconds = 29000

  # Mapping Templates
  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
  passthrough_behavior = "WHEN_NO_MATCH"
}

# OPTIONS /foo Integration 200 Response
resource "aws_api_gateway_integration_response" "foo_options_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.foo.id
  http_method = aws_api_gateway_method.foo_options.http_method
  status_code = "200"

  # Header Mappings
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# --- GET

# GET /foo
resource "aws_api_gateway_method" "foo_get" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.foo.id
  http_method   = "GET"
  authorization = "NONE"

  # Query Parameters
  request_validator_id = aws_api_gateway_request_validator.parameters.id
  request_parameters   = {
    "method.request.querystring.bar" = true
  }
}

# GET /foo 200 Response
resource "aws_api_gateway_method_response" "foo_get_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.foo.id
  http_method = aws_api_gateway_method.foo_get.http_method
  status_code = "200"

  # Response Body
  response_models = {
    "application/json" = "Empty"
  }
}

# GET /foo Integration
resource "aws_api_gateway_integration" "foo_get_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.foo.id
  http_method             = aws_api_gateway_method.foo_get.http_method
  timeout_milliseconds    = 29000

  # Lambda Integration
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.foo_handler.invoke_arn
  content_handling        = "CONVERT_TO_TEXT"
}

# --- Validators

resource "aws_api_gateway_request_validator" "parameters" {
  name                        = "Validate query string parameters and headers"
  rest_api_id                 = aws_api_gateway_rest_api.this.id
  validate_request_parameters = true
}

