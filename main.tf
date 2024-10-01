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

  # Assuming you have your Lambda code packaged in a zip file
  filename      = "lambda_function_payload.zip"
  ......
}


# Lambda functions typically need permissions to write logs to CloudWatch. You can attach the AWSLambdaBasicExecutionRole managed policy to the IAM role.
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Create an S3 Bucket Notification to Trigger Lambda when a new image is uploaded in S3
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.my_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.my_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
    filter_prefix       = "images/"
  }

  depends_on = [
    aws_lambda_permission.allow_s3_invoke
  ]
}


# Grant s3 permission to invoke the lambda fn
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my_bucket.arn
}
