output "s3_bucket_name" {
  value = aws_s3_bucket.tf_remote_state.bucket
  description = "The name of Bucket created to store Terraform State Files"
}

output "dynamodb_table_name" {
  value =  aws_dynamodb_table.tf_state_locking.name
  description = "The name of the DynamoDB Table that will be used to store Lock Files and manage concurrence access"  
}