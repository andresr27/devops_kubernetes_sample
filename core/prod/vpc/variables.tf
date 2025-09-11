#variable is used to declare the variable and word after in "" is the name of the variables

variable "aws_account" {
  type        = string
  description = "The AWS Account Number to deploy Terraform resources to"
}

variable "aws_region" {
  type        = string
  description = "The AWS Region to deploy Terraform resources to, default Region is on Oregon(us-west-2)"
  default     = "us-west-2"
}
variable "env_prefix" {
  type        = string
  description = "Enviroment prefix. Ex: DA-Bdevcore-Dev"
}
variable "businessowner" {
  type        = string
  description = "Tag for Business Owner. Ex: email account"
}
variable "businessunit" {
  type        = string
  description = "Tag for Business Unit. Ex: RD, WD, IT"
}
variable "env" {
  type        = string
  description = "Tag for enviroment. Ex: Dev or Prod"
}
variable "app" {
  type        = string
  description = "Tag for app. Ex: AWS"
}
#this will be same in most cases
variable "domain_name" {
  type        = string
  description = "Domain Name"
  default     = "bairesdev.com"
}
variable "availability_zone_a" {
  type        = string
  description = "Availability Zone name"
}
variable "availability_zone_b" {
  type        = string
  description = "Availability Zone name"
}
#variable "availability_zone_c" {
#  type        = string
#  description = "Availability Zone name"
#}
variable "cidr" {
  type = map(any)
}