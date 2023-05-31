module "ResourceGroup" {
  source    = "../ResourceGroup"
  base_name = "server"
}

module "VNet" {
  source = "../VNet"
}

resource "azurerm_virtual_network" "webserver-net" {
  name                = "sambatra-webserver-net"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = module.ResourceGroup.rg_name_out
}

resource "azurerm_subnet" "webserver-subnet" {
  name                 = "subnet"
  resource_group_name  = module.ResourceGroup.rg_name_out
  virtual_network_name = azurerm_virtual_network.webserver-net.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "webserver" {
  name                = "nginx-interface"
  location            = "West Europe"
  resource_group_name = module.ResourceGroup.rg_name_out

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.webserver-subnet.id
    public_ip_address_id          = azurerm_public_ip.webserver_public_ip.id
  }

  depends_on = [module.ResourceGroup.webserver]
}

resource "azurerm_public_ip" "webserver_public_ip" {
   name = "webserver_public_ip"
   location = var.location
   resource_group_name = module.ResourceGroup.rg_name_out
   allocation_method = "Dynamic"

   tags = {
       environment = var.prod
       costcenter = "it"
   }

   depends_on = [module.ResourceGroup.webserver]
}

resource "azurerm_linux_virtual_machine" "nginx-staging" {
  size                = var.instance_size
  name                = "nginx-webserver-staging"
  resource_group_name = module.ResourceGroup.rg_name_out
  location            = "West Europe"
  custom_data         = base64encode(file("init-script.sh"))
  network_interface_ids = [

    azurerm_network_interface.webserver.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "nginx-staging"
  admin_username                  = "adminuser"
  admin_password                  = "Faizan@bashir.123"
  disable_password_authentication = false

  os_disk {
    name    = "nginxdisk01"
    caching = "ReadWrite"
    #create_option = "FromImage"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    environment = var.staging
    costcenter  = "it"
  }

  depends_on = [module.ResourceGroup.rg_name_out]
}

