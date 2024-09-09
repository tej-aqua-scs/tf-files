resource "azurerm_storage_account" "storage_account" {
  name                            = var.storage_account
  resource_group_name             = var.resource_group
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.replication_type
  public_network_access_enabled   = var.public_network_access_enabled
  allow_nested_items_to_be_public = false
  blob_properties {
    dynamic "delete_retention_policy" {
      for_each = range((var.delete_retention_policy_days) > 0 ? 1 : 0)

      content {
        days = var.delete_retention_policy_days
      }
    }
    dynamic "container_delete_retention_policy" {
      for_each = range((var.container_delete_retention_policy_days) > 0 ? 1 : 0)

      content {
        days = var.container_delete_retention_policy_days
      }
    }
    # dynamic "cors_rule" {
    #   for_each = var.cors_rule

    #   content {
    #     allowed_headers    = cors_rule.value.allowed_headers
    #     allowed_methods    = cors_rule.value.allowed_methods
    #     allowed_origins    = cors_rule.value.allowed_origins
    #     exposed_headers    = cors_rule.value.exposed_headers
    #     max_age_in_seconds = cors_rule.value.max_age_in_seconds
    #   }
    # }
    versioning_enabled = var.versioning_enabled
    # last_access_time_enabled = length(var.retention_rules) > 0 ? true : null
  }

  network_rules {
    default_action             = var.allow_public_access ? "Allow" : "Deny"
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [network_rules[0].ip_rules]
  }
}

