
resource "azurerm_virtual_network" "demo" {
    name = "demo-network"
    location = var.location
    resource_group_name = azurerm_resource_group.demo.name
    address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "demo-subnet-1" {
    name = "demo-subnet-1"
    resource_group_name = azurerm_resource_group.demo.name
    virtual_network_name = azurerm_virtual_network.demo.name
    address_prefix = "10.0.0.0/24"
}

resource "azurerm_network_security_group" "demo-instance" {
    name = "demo-instance-nsg"
    location = var.location
    resource_group_name = azurerm_resource_group.demo.name
    security_rule {
        
      name                   = "ssh"
      priority               = 1001
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = var.ssh-source-address
      destination_address_prefix = "*"
      description            = "description-myssh"
    }
    security_rule {
        
      name                   = "http"
      priority               = 1002
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      source_port_range      = "*"
      destination_port_range = "80"
      source_address_prefix  = var.ssh-source-address
      destination_address_prefix = "*"
      description            = "description-myssh"
    }
}
