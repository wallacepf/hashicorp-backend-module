variable "db_address" {
  description = "Postgres DB Address"
  type        = string
}

variable "backend_instance_count" {
  description = "number of backend servers"
  type        = number
  default     = 1
}

variable "backend_name" {
  description = "Backend server name"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "var.instance_type" {
  description = "Instance size"
  default     = "t2.micro"
}

variable "key_name" {
  description = "your key-par name"
}

variable "backend_subnets" {
  description = "subnet where your backend will reside"
}

variable "security_group" {
  description = "backend security groups"
}

variable "app_s3_addr" {
  description = "S3 address where the application is"
}
