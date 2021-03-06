variable "admin_username" {
  default	= "consuldemo"
}

variable "consul_encrypt" {
  default="oGKwo6QPhN7Kq2gENftlAw=="
}

variable "consul_version" {
  default="1.4.0"
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

variable "consul_server_subnet_address" {
  default = "192.168.0.0/28"
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
variable "subscription_id" {
  default="null"
}
variable "tenant_id" {
  default="null"
}
variable "client_id" {
  default="null"
}
variable "secret_access_key" {
  default="null"
}


