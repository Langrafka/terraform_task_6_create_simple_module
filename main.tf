# ----------------------------------------------------
# 1. КОНФІГУРАЦІЯ TERRAFORM ТА ПРОВАЙДЕРА AZURE
# ----------------------------------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ----------------------------------------------------
# 2. ВИКЛИК ОПУБЛІКОВАНОГО МОДУЛЯ (Крок 5)
# ----------------------------------------------------
module "prod_infra_via_registry" {
  # !!! ВИПРАВЛЕНО: Закриті лапки та додано шлях до підмодуля !!!
  source  = "git::https://github.com/Langrafka/terraform-azurerm-resource_group_storage.git//modules/resource_group_storage?ref=v1.0.3"
  # !!! ОНОВЛЕНО: Використовуємо новий, чистий тег !!!
  version = "1.0.3"

  # Змінні, що передаються у ваш модуль
  resource_group_name  = "rg-module-final-test"
  storage_account_name = "finalsaregistrytest1" # МАЄ БУТИ ГЛОБАЛЬНО УНІКАЛЬНИМ!
  location             = "East US"
  environment_tag      = "ModuleTaskFinal"

  # Опціональні змінні
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# ----------------------------------------------------
# 3. ВИХІДНІ ДАНІ
# ----------------------------------------------------
output "final_rg_id" {
  description = "The ID of the Resource Group created by the published module."
  value       = module.prod_infra_via_registry.resource_group_id
}

# (Додано Output для Storage Key для повноти)
output "final_storage_key" {
    description = "The primary access key for the Storage Account."
    value       = module.prod_infra_via_registry.storage_account_primary_access_key
    sensitive   = true
}