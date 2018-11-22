variable "admin_sshkey" {}

variable "admin_username" {
  default	= "consuldemo"
}

variable "consul_encrypt" {
  default="oGKwo6QPhN7Kq2gENftlAw=="
}


variable "instance_count" {
  default = 3
}

variable "location" {
  default = "canadacentral"
}


variable "prefix" {
  default = "rkconsul"
}

variable "subnet_space" {
  default = "192.168.0.0"
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