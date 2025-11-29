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
# Назва модуля змінена на "resource_group_storage" для проходження CI/CD.
# Source оновлено до формату Terraform Registry відповідно до вимог ментора.
# ----------------------------------------------------
module "resource_group_storage" {
  # Формат Registry: <NAMESPACE>/<NAME_WITHOUT_PREFIX>/<PROVIDER>//<PATH_TO_SUBMODULE>
  source  = "Langrafka/resource_group_storage/azurerm//modules/resource_group_storage"

  # Використовуємо останній, чистий тег
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
# Outputs посилаються на оновлену назву модуля
output "final_rg_id" {
  description = "The ID of the Resource Group created by the published module."
  value       = module.resource_group_storage.resource_group_id
}

output "final_storage_key" {
    description = "The primary access key for the Storage Account."
    value       = module.resource_group_storage.storage_account_primary_access_key
    sensitive   = true
}