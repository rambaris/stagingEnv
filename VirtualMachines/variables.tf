variable "location" {
   type = string
   description = "Region"
   default = "West Europe"
}

variable "staging" {
   type = string
   description = "Environment"
   default = "staging"
}
variable "prod" {
   type = string
   description = "Environment"
   default = "prod"
}

variable "instance_size" {
   type = string
   description = "Azure instance size"
   default = "Standard_F2"
}