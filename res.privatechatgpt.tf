locals {
    key_vault_firewall_allow_list = concat([local.build_agent_ip], var.keyvault_firewall_allowed_ips)
}


module "private-chatgpt-openai" {
  source  = "Pwd9000-ML/openai-private-chatgpt/azurerm"
  version = ">= 1.1.0"

  #common
  location = var.location
  tags     = var.default_tags

  #keyvault (OpenAI Service Account details)
  kv_config                                    = var.kv_config
  keyvault_resource_group_name                 = azurerm_resource_group.rg.name
  keyvault_firewall_default_action             = var.keyvault_firewall_default_action
  keyvault_firewall_bypass                     = var.keyvault_firewall_bypass
  keyvault_firewall_allowed_ips                = local.key_vault_firewall_allow_list
  keyvault_firewall_virtual_network_subnet_ids = var.keyvault_firewall_virtual_network_subnet_ids

  #Create OpenAI Service?
  create_openai_service                     = var.create_openai_service
  openai_resource_group_name                = azurerm_resource_group.rg.name
  openai_account_name                       = var.openai_account_name
  openai_custom_subdomain_name              = var.openai_custom_subdomain_name
  openai_sku_name                           = var.openai_sku_name
  openai_local_auth_enabled                 = var.openai_local_auth_enabled
  openai_outbound_network_access_restricted = var.openai_outbound_network_access_restricted
  openai_public_network_access_enabled      = var.openai_public_network_access_enabled
  openai_identity                           = var.openai_identity

  #Create Model Deployment?
  create_model_deployment = var.create_model_deployment
  model_deployment        = var.model_deployment

  #Create a solution log analytics workspace to store logs from our container apps instance
  laws_name              = var.laws_name
  laws_sku               = var.laws_sku
  laws_retention_in_days = var.laws_retention_in_days

  #Create Container App Enviornment
  cae_name = var.cae_name

  #Create a container app instance
  ca_resource_group_name = azurerm_resource_group.rg.name
  ca_name                = var.ca_name
  ca_revision_mode       = var.ca_revision_mode
  ca_identity            = var.ca_identity
  ca_container_config    = var.ca_container_config

  #Create a container app secrets
  ca_secrets = local.ca_secrets

  #key vault access
  key_vault_access_permission = var.key_vault_access_permission
  key_vault_id                = data.azurerm_key_vault.gpt.id

  #Create front door CDN
  create_front_door_cdn = var.create_front_door_cdn
}