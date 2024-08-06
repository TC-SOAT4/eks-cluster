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

#Ajustar para o iam do conta
variable "principalArn" {
  default = "arn:aws:iam::786426553713:role/voclabs"
}

variable "authenticationMode" {
  default = "API_AND_CONFIG_MAP"
}



