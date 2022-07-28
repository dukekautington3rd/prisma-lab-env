variable "AWS_ACCESS_KEY_ID" {
  type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
}

variable "PCC_ACCESS_KEY_ID" {
  type = string
}

variable "PCC_SECRET_ACCESS_KEY" {
  type = string
}

variable "PCC_URL" {
  type = string
}

variable "PCC_IMAGE" {
  type = string
}

variable "PCC_WS_ADDRESS" {
  type = string
}

variable "PCC_SERVICE_PARAMETER" {
  type = string
}

variable "PCC_INSTALL_BUNDLE" {
  type = string
}

variable "PCC_DEFENDER_CLIENT_KEY" {
  type = string
}

variable "PCC_DEFENDER_CLIENT_CERT" {
  type = string
}

variable "PCC_DEFENDER_CA" {
  type = string
}

variable "PCC_ADMISSION_KEY" {
  type = string
}

variable "PCC_ADMISSION_CERT" {
  type = string
}

variable "PCC_VWH_CA" {
  type = string
}

variable "key_pair" {
  description = "Key pair to be used on ec2 instances"
  type        = string
}

variable "region" {
  description = "AWS region to launch servers"
  type        = string
}

variable "admin_ip" {
  description = "admin IP addresses in CIDR format"
}
