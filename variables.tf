variable "region" {
  default = "ap-southeast-2"
}

variable "vpc_name" {
  default = "charan-vpc"
}

variable "ec2_names" {
  default = ["char-1", "char-2", "char-3"]
}

variable "rds_name" {
  default = "charan-rd"
}

variable "s3_prefix" {
  default = "charan-s3"
}

variable "db_password" {
  sensitive = true
}