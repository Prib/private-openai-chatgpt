data "azurerm_key_vault" "gpt" {
  name                = var.kv_name
  resource_group_name = var.resource_group_name
  depends_on          = [module.private-chatgpt-openai.key_vault_id]
}