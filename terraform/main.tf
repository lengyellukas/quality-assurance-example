provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "tfstate120920"
    container_name       = "tfstate"
    key                  = "key1"
    access_key           = "Zr7G5/BvuaWTzK+CyN1td+kTURMBzKVsANUwLlyroAsLJREIOvg9Ci3LvPTN6wnruH6QJhg8w6xv+AStTYjRYg=="
  }
}
module "resource_group" {
  source               = "./modules/resource_group"
  resource_group       = "tfstate"
  location             = "${var.location}"
}
module "network" {
  source               = "./modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${module.resource_group.resource_group_name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "./modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = "${module.resource_group.resource_group_name}"
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
}
module "appservice" {
  source           = "./modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${module.resource_group.resource_group_name}"
}
module "publicip" {
  source           = "./modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${module.resource_group.resource_group_name}"
}

module "vm" {
  source = "./modules/vm"
  name = "test-lengyel"
  location = "${var.location}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  size = "Standard_B1s"
  admin_username = "lukas.lengyel@outlook.com"
  username = "lukas.lengyel@outlook.com"
  subnet_id = "${module.network.subnet_id_test}"
  public_ip_address_id = "${module.publicip.public_ip_address_id}"
}