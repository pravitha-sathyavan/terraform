
# Step 1: Create an S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-comprehensive-s3-bucket"
}

# Step 2: Set Bucket Policy (to allow public read access for a specific object prefix)
resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:GetObject"],
        Effect = "Allow", 
        Resource = "${aws_s3_bucket.my_bucket.arn}/public/*", 
        Principal = "*"
      }
    ]
  })
}

# Resources: bucket and objects
# Effect: Allow/Deny
# Action: API like GetObject to allow/deny
# Principal: The user or account to apply the policy to

# If we want to give an EC2 instance access to S3 bucket, then create an EC2 instance role with correct IAM permissions and then EC2 instance will be able to access the S3 bucket.

#Enable versioning in s3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-versioned-bucket"

  versioning {
    enabled = true
  }
}
