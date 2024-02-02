#locals {
#  create_default_deny_nsg_rule_name_prefix = var.create_default_deny_nsg_rule_policy.name
#  create_default_deny_nsg_rule_name_hash   = substr(md5(local.create_default_deny_nsg_rule_name_prefix), 0, 12)
#}
#
#
#resource "azurerm_policy_definition" "create_default_deny_nsg_rule_policy" {
#  name                = local.create_default_deny_nsg_rule_name_hash
#  policy_type         = "Custom"
#  mode                = "All"
#  display_name        = "${var.policy_prefix} - Create Default Deny NSG Rule exists"
#  description         = var.create_default_deny_nsg_rule_policy.description != null ? var.create_default_deny_nsg_rule_policy.description : "This policy allows specific roles for specific principalTypes, appends the a default rule to all NSGs in the scope.  This only works during creation and update."
#  management_group_id = var.create_default_deny_nsg_rule_policy.management_group_id != null ? var.create_default_deny_nsg_rule_policy.management_group_id : (var.attempt_read_tenant_root_group ? data.azurerm_management_group.tenant_root_group[0].id : null)
#
#  metadata = jsonencode({
#    version  = "1.0.0",
#    category = "Networking"
#    author   = var.policy_prefix
#  })
#
#  policy_rule = jsonencode({
#    "if" = {
#      "allOf" = [
#        {
#          "field"  = "type",
#          "equals" = "Microsoft.Network/networkSecurityGroups"
#        }
#      ]
#    },
#    "then" = {
#      "effect" = "[parameters('effect')]",
#      "details" = [
#        {
#          "field" = "Microsoft.Network/networkSecurityGroups/securityRules[*]",
#          "value" = {
#            "name" = "[parameters('name')]",
#            "properties" = {
#              "protocol"                   = "[parameters('protocol')]",
#              "sourcePortRange"            = "[if(equals(length(parameters('sourcePortRanges')), 1), first(parameters('sourcePortRanges')), '')]",
#              "destinationPortRange"       = "[if(equals(length(parameters('destinationPortRanges')), 1), first(parameters('destinationPortRanges')), '')]",
#              "sourceAddressPrefix"        = "[if(equals(length(parameters('sourceAddressPrefixes')), 1), first(parameters('sourceAddressPrefixes')), '')]",
#              "destinationAddressPrefix"   = "[if(equals(length(parameters('destinationAddressPrefixes')), 1), first(parameters('destinationAddressPrefixes')), '')]",
#              "access"                     = "[parameters('access')]",
#              "priority"                   = "[parameters('priority')]",
#              "direction"                  = "[parameters('direction')]",
#              "sourcePortRanges"           = "[if(greater(length(parameters('sourcePortRanges')), 1), parameters('sourcePortRanges'), take(parameters('sourcePortRanges'),0))]",
#              "destinationPortRanges"      = "[if(greater(length(parameters('destinationPortRanges')), 1), parameters('destinationPortRanges'), take(parameters('destinationPortRanges'),0))]",
#              "sourceAddressPrefixes"      = "[if(greater(length(parameters('sourceAddressPrefixes')), 1), parameters('sourceAddressPrefixes'), take(parameters('sourceAddressPrefixes'),0))]",
#              "destinationAddressPrefixes" = "[if(greater(length(parameters('destinationAddressPrefixes')), 1), parameters('destinationAddressPrefixes'), take(parameters('destinationAddressPrefixes'),0))]"
#            }
#          }
#        }
#      ]
#    }
#  })
#
#  parameters = jsonencode({
#    "name" = {
#      "type" = "String"
#    },
#    "protocol" = {
#      "type" = "String",
#      "allowedvalues" = [
#        "TCP",
#        "UDP",
#        "ICMP",
#        "*"
#      ]
#    },
#    "access" = {
#      "type" = "String",
#      "allowedvalues" = [
#        "Allow",
#        "Deny"
#      ]
#    },
#    "priority" = {
#      "type" = "String"
#    },
#    "direction" = {
#      "type" = "String",
#      "allowedvalues" = [
#        "Inbound",
#        "Outbound"
#      ]
#    },
#    "sourcePortRanges" = {
#      "type" = "Array"
#    },
#    "destinationPortRanges" = {
#      "type" = "Array"
#    },
#    "sourceAddressPrefixes" = {
#      "type" = "Array"
#    },
#    "destinationAddressPrefixes" = {
#      "type" = "Array"
#    },
#    "effect" = {
#      "type" = "String",
#      "metadata" = {
#        "displayName" = "Effect",
#        "description" = "Append, Deny, Audit or Disable the execution of the Policy"
#      },
#      "allowedValues" = [
#        "Append",
#        "Deny",
#        "Audit",
#        "Disabled"
#      ],
#      "defaultValue" = "Append"
#    }
#  })
#}
#
#
#resource "azurerm_management_group_policy_assignment" "create_default_deny_nsg_rule_assignment" {
#  count                = var.create_default_deny_nsg_rule_policy.deploy_assignment ? 1 : 0
#  name                 = azurerm_policy_definition.create_default_deny_nsg_rule_policy.name
#  management_group_id  = var.create_default_deny_nsg_rule_policy.management_group_id != null ? var.create_default_deny_nsg_rule_policy.management_group_id : (var.attempt_read_tenant_root_group ? data.azurerm_management_group.tenant_root_group[0].id : null)
#  policy_definition_id = azurerm_policy_definition.create_default_deny_nsg_rule_policy.id
#  enforce              = var.create_default_deny_nsg_rule_policy.enforce != null ? var.create_default_deny_nsg_rule_policy.enforce : true
#  display_name         = azurerm_policy_definition.create_default_deny_nsg_rule_policy.display_name
#  description          = var.create_default_deny_nsg_rule_policy.description != null ? var.create_default_deny_nsg_rule_policy.description : "This policy sets an NSG rule inside an NSG based on parameters."
#
#  non_compliance_message {
#    content = var.create_default_deny_nsg_rule_policy.non_compliance_message != null ? var.create_default_deny_nsg_rule_policy.non_compliance_message : "PlatformPolicyInfo: The NSG you have tried to deploy has been restricted by ${azurerm_policy_definition.create_default_deny_nsg_rule_policy.display_name} policy. This policy ensures an NSG rule is deployed. Please contact your administrator for assistance."
#  }
#
#  parameters = jsonencode({
#    "name" = {
#      "value" = var.create_default_deny_nsg_rule_policy.nsg_rule_name
#    }
#    "protocol" = {
#      "value" = var.create_default_deny_nsg_rule_policy.protocol
#    }
#    "access" = {
#      "value" = var.create_default_deny_nsg_rule_policy.access
#    }
#    "priority" = {
#      "value" = var.create_default_deny_nsg_rule_policy.priority
#    }
#    "direction" = {
#      "value" = var.create_default_deny_nsg_rule_policy.direction
#    }
#    "sourcePortRanges" = {
#      "value" = var.create_default_deny_nsg_rule_policy.source_port_ranges
#    }
#    "destinationPortRanges" = {
#      "value" = var.create_default_deny_nsg_rule_policy.destination_port_ranges
#    }
#    "sourceAddressPrefixes" = {
#      "value" = var.create_default_deny_nsg_rule_policy.source_address_prefixes
#    }
#    "destinationAddressPrefixes" = {
#      "value" = var.create_default_deny_nsg_rule_policy.destination_address_prefixes
#    }
#    "effect" = {
#      "value" = var.create_default_deny_nsg_rule_policy.effect
#    }
#  })
#}
#