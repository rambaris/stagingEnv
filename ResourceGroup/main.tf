resource "azurerm_resource_group" "webserver" {
   name = "${var.base_name}sambatra-nginx-staging"
   location = var.location
}
