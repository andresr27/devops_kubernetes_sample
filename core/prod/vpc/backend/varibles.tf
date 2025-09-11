variable "s3_bucket_name" {
    type = string
    description = "The name of Bucket created to store Terraform State Files"
}
  
variable "dynamodb_table_name" {
    type = string
    description = "The name of the DynamoDB Table that will be used to store Lock Files and manage concurrence access"  
}
  
