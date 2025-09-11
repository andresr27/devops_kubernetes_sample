#.... s3 bucket for terraform state

resource "aws_s3_bucket" "tf_remote_state" {
  bucket = "${var.s3_bucket_name}"
}

resource "aws_s3_bucket_acl" "tf_remote_state" {
  bucket = aws_s3_bucket.tf_remote_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_tf_remote_state" {
  bucket = aws_s3_bucket.tf_remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


#.... DynamoDB for locking the state file

resource "aws_dynamodb_table" "tf_state_locking" {
  hash_key = "LockID"
  name     = "${var.dynamodb_table_name}"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}