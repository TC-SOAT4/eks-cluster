variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "serviceIpv4" {
  default = "10.100.0.0/16"
}

variable "eksVersion" {
  default = "1.29"
}

variable "awsIamRole" {
  default = "LabRole"
}

variable "authenticationMode" {
  default = "API_AND_CONFIG_MAP"
}

