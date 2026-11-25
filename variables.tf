variable "charan_name" {
  default = "charan"
}

variable "mumbai_region" {
  default = "ap-south-1"
}

variable "db_pass" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "CharanSecure123!"
}
