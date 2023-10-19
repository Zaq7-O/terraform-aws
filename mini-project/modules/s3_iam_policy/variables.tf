variable "suffix" {
  type        = string
  description = "Unique suffix added to resource names"
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN for read/write policies"
}

variable "s3_kms_key" {
  description = "KMS Key used by S3 bucket"
}