resource "azurerm_lb" "demo" {
    name = "demo-loadbalancer"
    sku = length(var.zones) == 0 ? "Basic" : "Standard" #basic is free but doent support az
    location = var.location
    resource_group_name = azurerm_resource_group.demo.name 

    front_end_ip_configuration {
        name = "PublicIpAddress"
        public_ip_address_id = azurerm_public_ip.demo.id 
    }
}
resource "azurerm_public_ip" "demo" {
    name = "demo-public-ip"
    location = var.location
    resource_group_name = azurerm_resource_group.demo.name 
    allocation_method = "Static"
    domain_name_label = azurerm_resource_group.demo.name 
    sku = length(var.zones) == 0 ? "Basic" : "Standard" #basic is free but doent support az
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
    resource_group_name = azurerm_resource_group.demo.name 
    loadbalancer_id = azurerm_lb.demo.id
    name = "BackEndAddressPool"
}
resource "azurerm_lb_nat_pool" "lbnatrool" {
  resource_group_name            = azurerm_resource_group.demo.name
  loadbalancer_id                = azurerm_lb.demo.id
  name                           = "ssh"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}
resource "azurerm_lb_probe" "demo" {
  resource_group_name = azurerm_resource_group.demo.name
  loadbalancer_id     = azurerm_lb.demo.id
  name                = "http-probe"
  request_path = "/"
  port                = 80
}
resource "azurerm_lb_probe" "demo" {
  resource_group_name = azurerm_resource_group.demo.name
  loadbalancer_id     = azurerm_lb.demo.id
  name                = "LBRule"
  protocol = "Tcp"
  front_end_port = 80
  backend_end_port = 80
  front_end_ip_configuration = "PublicIPAddress"
  probe_id = azure_lb_probe.demo.id 
  backend_address_poll_id = azurerm_lb_backend_address_pool.bpepool.id
 }