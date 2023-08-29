# ##############################################################################
# # Variables File
# # 
# # Here is where we store the default values for all the variables used in our
# # Terraform code. If you create a variable with no default, the user will be
# # prompted to enter it (or define it via config file or command line flags.)

# # Variables which will be updated when the cookie cutter template created the solution


# # General Variables for the EAI Environment 
# variable "general_prefix_lowercase" {
#   description = "The name of the environment"
#   default     = "demo"
# }

variable "main_resource_group" {
  description = "The name of the resource group"
  default     = ""
}

# Used to specify common application level settings to resources
variable "default_tags" {
    type = map
    default = {        
        Environment = "__CommonSetting_EnvironmentName_LowerCase__"
        deployed_by = "terraform"
        Application = "OpenAI Private ChatGPT"   
    }
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "Azure region where resources will be hosted."
}

variable "kv_config" {
  type = object({
    name = string
    sku  = string
  })
  default = {
    name = "gptkv"
    sku  = "standard"
  }
  description = "Key Vault configuration object to create azure key vault to store openai account details."
  nullable    = false
}

variable "keyvault_firewall_default_action" {
  type        = string
  default     = "Deny"
  description = "Default action for keyvault firewall rules."
}

variable "keyvault_firewall_bypass" {
  type        = string
  default     = "AzureServices"
  description = "List of keyvault firewall rules to bypass."
}

variable "keyvault_firewall_allowed_ips" {
  type        = list(string)
  default     = []
  description = "value of keyvault firewall allowed ip rules."
}

variable "keyvault_firewall_virtual_network_subnet_ids" {
  type        = list(string)
  default     = []
  description = "value of keyvault firewall allowed virtual network subnet ids."
}

### openai service ###
variable "create_openai_service" {
  type        = bool
  description = "Create the OpenAI service."
  default     = false
}

variable "openai_account_name" {
  type        = string
  description = "Name of the OpenAI service."
  default     = "demo-account"
}

variable "openai_custom_subdomain_name" {
  type        = string
  description = "The subdomain name used for token-based authentication. Changing this forces a new resource to be created. (normally the same as the account name)"
  default     = "demo-account"
}

variable "openai_sku_name" {
  type        = string
  description = "SKU name of the OpenAI service."
  default     = "S0"
}

variable "openai_local_auth_enabled" {
  type        = bool
  default     = true
  description = "Whether local authentication methods is enabled for the Cognitive Account. Defaults to `true`."
}

variable "openai_outbound_network_access_restricted" {
  type        = bool
  default     = false
  description = "Whether or not outbound network access is restricted. Defaults to `false`."
}

variable "openai_public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Whether or not public network access is enabled. Defaults to `false`."
}

variable "openai_identity" {
  type = object({
    type = string
  })
  default = {
    type = "SystemAssigned"
  }
  description = <<-DESCRIPTION
    type = object({
      type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.
      identity_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.
    })
  DESCRIPTION
}

### model deployment ###
variable "create_model_deployment" {
  type        = bool
  description = "Create the model deployment."
  default     = false
}

variable "model_deployment" {
  type = list(object({
    deployment_id   = string
    model_name      = string
    model_format    = string
    model_version   = string
    scale_type      = string
    scale_tier      = optional(string)
    scale_size      = optional(number)
    scale_family    = optional(string)
    scale_capacity  = optional(number)
    rai_policy_name = optional(string)
  }))
  default     = []
  description = <<-DESCRIPTION
      type = list(object({
        deployment_id   = (Required) The name of the Cognitive Services Account `Model Deployment`. Changing this forces a new resource to be created.
        model_name = {
          model_format  = (Required) The format of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created. Possible value is OpenAI.
          model_name    = (Required) The name of the Cognitive Services Account Deployment model. Changing this forces a new resource to be created.
          model_version = (Required) The version of Cognitive Services Account Deployment model.
        }
        scale = {
          scale_type     = (Required) Deployment scale type. Possible value is Standard. Changing this forces a new resource to be created.
          scale_tier     = (Optional) Possible values are Free, Basic, Standard, Premium, Enterprise. Changing this forces a new resource to be created.
          scale_size     = (Optional) The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. Changing this forces a new resource to be created.
          scale_family   = (Optional) If the service has different generations of hardware, for the same SKU, then that can be captured here. Changing this forces a new resource to be created.
          scale_capacity = (Optional) Tokens-per-Minute (TPM). If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted. Default value is 1. Changing this forces a new resource to be created.
        }
        rai_policy_name = (Optional) The name of RAI policy. Changing this forces a new resource to be created.
      }))
  DESCRIPTION
  nullable    = false
}

### log analytics workspace ###
variable "laws_name" {
  type        = string
  description = "Name of the log analytics workspace to create."
  default     = "gptlaws"
}

variable "laws_sku" {
  type        = string
  description = "SKU of the log analytics workspace to create."
  default     = "PerGB2018"
}

variable "laws_retention_in_days" {
  type        = number
  description = "Retention in days of the log analytics workspace to create."
  default     = 30
}

### container app environment ###
variable "cae_name" {
  type        = string
  description = "Name of the container app environment to create."
  default     = "gptcae"
}

### container app ###
variable "ca_name" {
  type        = string
  description = "Name of the container app to create."
  default     = "gptca"
}

variable "ca_revision_mode" {
  type        = string
  description = "Revision mode of the container app to create."
  default     = "Single"
}

variable "ca_identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default     = {
    type = "SystemAssigned"
  }
  description = <<-DESCRIPTION
    type = object({
      type         = (Required) The type of the Identity. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned`.
      identity_ids = (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this OpenAI Account.
    })
  DESCRIPTION
}

variable "ca_ingress" {
  type = object({
    allow_insecure_connections = optional(bool)
    external_enabled           = optional(bool)
    target_port                = number
    transport                  = optional(string)
    traffic_weight = optional(object({
      percentage      = number
      latest_revision = optional(bool)
    }))
  })
  default = {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 3000
    transport                  = "auto"
    traffic_weight = {
      percentage      = 100
      latest_revision = true
    }
  }
  description = <<-DESCRIPTION
    type = object({
      allow_insecure_connections = (Optional) Allow insecure connections to the container app. Defaults to `false`.
      external_enabled           = (Optional) Enable external access to the container app. Defaults to `true`.
      target_port                = (Required) The port to use for the container app. Defaults to `3000`.
      transport                  = (Optional) The transport protocol to use for the container app. Defaults to `auto`.
      type = object({
        percentage      = (Required) The percentage of traffic to route to the container app. Defaults to `100`.
        latest_revision = (Optional) The percentage of traffic to route to the container app. Defaults to `true`.
      })
  DESCRIPTION
}

variable "ca_container_config" {
  type = object({
    name         = string
    image        = string
    cpu          = number
    memory       = string
    min_replicas = optional(number, 0)
    max_replicas = optional(number, 10)
    env = optional(list(object({
      name        = string
      secret_name = optional(string)
      value       = optional(string)
    })))
  })
  default = {
    name         = "gpt-chatbot-ui"
    image        = "ghcr.io/pwd9000-ml/chatbot-ui:main"
    cpu          = 1
    memory       = "2Gi"
    min_replicas = 0
    max_replicas = 10
    env          = []
  }
  description = <<-DESCRIPTION
    type = object({
      name                    = (Required) The name of the container.
      image                   = (Required) The name of the container image.
      cpu                     = (Required) The number of CPU cores to allocate to the container.
      memory                  = (Required) The amount of memory to allocate to the container in GB.
      min_replicas            = (Optional) The minimum number of replicas to run. Defaults to `0`.
      max_replicas            = (Optional) The maximum number of replicas to run. Defaults to `10`.
      env = list(object({
        name        = (Required) The name of the environment variable.
        secret_name = (Optional) The name of the secret to use for the environment variable.
        value       = (Optional) The value of the environment variable.
      }))
    })
  DESCRIPTION
}

variable "ca_secrets" {
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "secret1"
      value = "value1"
    },
    {
      name  = "secret2"
      value = "value2"
    }
  ]
  description = <<-DESCRIPTION
    type = list(object({
      name  = (Required) The name of the secret.
      value = (Required) The value of the secret.
    }))
  DESCRIPTION  
}

# Key Vault Access #
### key vault access ###
variable "key_vault_access_permission" {
  type        = list(string)
  default     = ["Key Vault Secrets User"]
  description = "The permission to grant the container app to the key vault. Set this variable to `null` if no Key Vault access is needed. Defaults to `Key Vault Secrets User`."
}

variable "key_vault_id" {
  type        = string
  default     = ""
  description = "(Optional) - The id of the key vault to grant access to. Only required if `key_vault_access_permission` is set."
}

# Front Door #
variable "create_front_door_cdn" {
  description = "Create a Front Door profile."
  type        = bool
  default     = false
}

