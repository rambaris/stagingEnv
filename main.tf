terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

module "ResourceGroup" {
  source = "./ResourceGroup"
  base_name = "server"
}

module "VirtualMachines" {
  source = "./VirtualMachines"
}

module "VNet" {
  source = "./VNet"

}



