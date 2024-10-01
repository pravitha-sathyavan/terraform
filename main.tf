# S3 OBJECTS
# Create a resource of type 'amazon s3 bucket'
resource "aws_s3_bucket" "resourceName"{
  bucket = "bucketName"
}

# LAMBDA FUNCTION
# For a lambda fn, we need to create a permissions policy. The policy gives your fn the permission it needs to access other AWS resources.
resource "aws_iam_policy" "lambdapolicy"{
  name = "lambdas3policy"
  policy = jsonencode({
    .....
  })
}

# Create an IAM executon role for the Lambda function that grants the Lambda fn permission to access AWS services and resources. 
resource "aws_iam_role" "lambda_role" {
  name = "lambda-s3-execution-role"
  assume_role_policy = jsonencode({
    .....
  })
}

# Attach the S3 access policy to the IAM role that your Lambda function will assume.
resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambdapolicy.arn
}

# Create the Lambda function itself and associate it with the IAM role you created.
resource "aws_lambda_function" "my_lambda" {
  function_name = "myLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  # Assuming you have your Lambda code packaged in a zip file
  filename      = "lambda_function_payload.zip"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.my_bucket.bucket
    }
  }
}
