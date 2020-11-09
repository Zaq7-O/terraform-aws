# Input variable definitions

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "vpc-one"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.1.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.1.1.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type    = bool
  default = true
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default     = {
    Terraform   = "true"
    Environment = "one"
  }
}
#############

variable "ami_id" {
  description = "Public AMI"
  type        = string
  default     = "ami-0eddd5d08379980d8"
}
variable "instance_type" {
  description = "instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "PEM key file"
  type        = string
  default     = "one"
}

variable "count_no" {
  description = "Number of instances"
  type        = string
  default     = "2"
}

variable "env" {
  default = "prod"
}
