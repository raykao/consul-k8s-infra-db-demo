terraform {
  required_version = ">= 0.11.10"
}
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  address_space       = ["${var.vnet_space}/${var.vnet_prefix}"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "default" {
  name                 = "default-subnet"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "${var.subnet_space}/${var.subnet_prefix}"
}

resource "azurerm_network_interface" "main" {
  count	              = "${var.instance_count}"
  name                = "${var.prefix}${format("%03d", count.index + 1)}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "${var.prefix}${format("%03d", count.index + 1)}-ip"
    subnet_id                     = "${azurerm_subnet.default.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id	        = "${element(azurerm_public_ip.main.*.id, count.index)}"
  }
}

resource "azurerm_public_ip" "main" {
  count	              = "${var.instance_count}"
  name                = "${var.prefix}${format("%03d", count.index + 1)}-pip"
  location	          = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label	  = "${var.prefix}${format("%03d", count.index + 1)}"
}

resource "azurerm_virtual_machine" "main" {
  count	                = "${var.instance_count}"
  name                  = "${var.prefix}${format("%03d", count.index + 1)}"
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.main.*.id, count.index)}"]
  vm_size               = "${var.vm_size}"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}osdisk${format("%03d", count.index + 1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}${format("%03d", count.index+1)}"
    admin_username = "${var.admin_username}"
    custom_data	   = "${data.template_file.consul_config.rendered}"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${var.admin_sshkey}"
    }
  }
}

data "template_file" "consul_config" {
  template = "${file("${path.root}/install_consul.sh")}"

  vars {
    consul_encrpyt = "${var.consul_encrypt}"
    consul_datacenter = "${var.location}"
    scale_set_name = "${var.scale_set_name}-server"
    subscription_id = "${var.subscription_id}"
    tenant_id = "${var.tenant_id}"
    client_id = "${var.client_id}"
    secret_access_key = "${var.secret_access_key}"
  }
}