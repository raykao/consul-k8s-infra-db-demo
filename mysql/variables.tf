variable "admin_username" {
  default	= "mysql"
}

variable "consul_encrypt" {
  default="oGKwo6QPhN7Kq2gENftlAw=="
}

variable "consul_version" {
  default="1.4.0"
}

variable "location" {
  default = "canadacentral"
}

variable "prefix" {
  default = "rkmysql"
}

variable "subnet_space" {
  default = "192.168.1.0"
}

variable "subnet_prefix" {
  default = "28"
}

variable "vm_size" {
  default = "Standard_D2s_v3"
}

variable "vnet_space" {
  default	= "192.168.0.0"
}

variable "vnet_prefix" {
  default = "16"
}

variable "scale_set_name" {
  default="null"
}