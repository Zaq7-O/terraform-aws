output "key_id" {
  description = "The KMS key ID we use to encrypt S3 objects by default"
  value       = aws_kms_key.this.id
}

output "key_arn" {
  description = "ARN of the KMS key we use to encrypt S3 objects by default"
  value       = aws_kms_key.this.arn
}

output "encrypt_arn" {
  description = "The IAM policy ARN which allows us to encrypt S3 objects"
  value       = aws_kms_key.this.id
}

output "decrypt_arn" {
  description = "The IAM policy ARN which allows us to decrypt S3 objects"
  value       = aws_kms_key.this.id
}
