variable "token" {
  type        = string
}

variable "cloud_id" {
  type        = string
}

variable "folder_id" {
  type        = string
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "vpc_name" {
  type        = string
  default     = "public"
  description = "VPC network&subnet name"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
}

variable "nat_instance_ip" {
  type        = string
  default     = "192.168.10.254"
  description = "nat_instance_ip"
}

variable "default_cidr_private" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
}

variable "vpc_name_private" {
  type        = string
  default     = "private"
  description = "VPC network&subnet name"
}