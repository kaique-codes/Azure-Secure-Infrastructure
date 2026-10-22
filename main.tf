locals {
  common_tags = merge(var.tags, {
    project     = "azure-secure-infrastructure"
    owner       = "portfolio"
    environment = "lab"
    managed_by  = "terraform"
  })

  subnets     = {
    app        = {
      name             = "${var.name_prefix}-snet-app"
      address_prefixes = [var.subnet_prefixes.app]
    }
    data       = {
      name             = "${var.name_prefix}-snet-data"
      address_prefixes = [var.subnet_prefixes.data]
    }
    management = {
      name             = "${var.name_prefix}-snet-management"
      address_prefixes = [var.subnet_prefixes.management]
    }
  }
}

resource "azurerm_resource_group" "this" {
  name     = "${var.name_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.name_prefix}-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.address_space
  tags                = local.common_tags
}

resource "azurerm_network_security_group" "this" {
  name                = "${var.name_prefix}-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.common_tags
}

resource "azurerm_network_security_rule" "deny_internet_inbound" {
  name                        = "Deny-Internet-Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_subnet" "this" {
  for_each                        = local.subnets

  name                            = each.value.name
  resource_group_name             = azurerm_resource_group.this.name
  virtual_network_name            = azurerm_virtual_network.this.name
  address_prefixes                = each.value.address_prefixes
  default_outbound_access_enabled = false
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = azurerm_subnet.this

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_log_analytics_workspace" "this" {
  count                        = var.enable_log_analytics ? 1 : 0

  name                         = "${var.name_prefix}-law"
  location                     = azurerm_resource_group.this.location
  resource_group_name          = azurerm_resource_group.this.name
  sku                          = "PerGB2018"
  retention_in_days            = 30
  local_authentication_enabled = false
  tags                         = local.common_tags
}
