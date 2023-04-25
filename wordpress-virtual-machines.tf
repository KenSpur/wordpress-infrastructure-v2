# public IP address
resource "azurerm_public_ip" "wordpress" {
  count               = 2
  name                = "pip-${var.org_infix}-${var.project_infix}-wordpress-${count.index}-${var.env_suffix}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Static"
}

# network interface
resource "azurerm_network_interface" "wordpress" {
  count               = 2
  name                = "nic-${var.org_infix}-${var.project_infix}-wordpress-${count.index}-${var.env_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.frontend.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.wordpress[count.index].id
  }
}

resource "azurerm_availability_set" "wordpress" {
  name                         = "avail-${var.org_infix}-${var.project_infix}-wordpress-${var.env_suffix}"
  location                     = data.azurerm_resource_group.main.location
  resource_group_name          = data.azurerm_resource_group.main.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
}

# image
data "azurerm_shared_image_version" "wordpress" {
  name                = var.wordpress_image_version
  image_name          = var.wordpress_image_name
  gallery_name        = var.image_gallery_name
  resource_group_name = var.image_resource_group_name
}

# virtual machine
resource "azurerm_linux_virtual_machine" "wordpress" {
  count               = 2
  name                = "vm-${var.org_infix}-${var.project_infix}-wordpress-${count.index}-${var.env_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  availability_set_id = azurerm_availability_set.wordpress.id
  size                = "Standard_B1s"

  network_interface_ids = [azurerm_network_interface.wordpress[count.index].id]

  admin_username = var.ssh_username
  admin_password = var.ssh_password

  disable_password_authentication = false

  source_image_id = data.azurerm_shared_image_version.wordpress.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}