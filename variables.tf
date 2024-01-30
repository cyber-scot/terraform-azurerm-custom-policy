variable "attempt_read_tenant_root_group" {
  type        = bool
  default     = true
  description = "Whether the module should attempt to read the tenant root group, your SPN may not have permissions"
}

variable "like_mandatory_resource_tagging_policy" {
  description = "Configuration for the mandatory resource tagging policy for the like"
  type = object({
    name                   = optional(string, "like-mandatory-tags")
    management_group_id    = optional(string)
    enforce                = optional(bool, true)
    non_compliance_message = optional(string)
    description            = optional(string)
    effect                 = optional(string, "Audit")
    required_tags = list(object({
      key     = string
      pattern = string
    }))
  })
}

variable "match_mandatory_resource_tagging_policy" {
  description = "Configuration for the mandatory resource tagging policy for the match pattern"
  type = object({
    name                   = optional(string, "match-mandatory-tags")
    management_group_id    = optional(string)
    enforce                = optional(bool, true)
    non_compliance_message = optional(string)
    description            = optional(string)
    effect                 = optional(string, "Audit")
    required_tags = list(object({
      key     = string
      pattern = string
    }))
  })
}

variable "non_privileged_role_restriction_policy" {
  description = "Configuration for the non privileged role restriction policy, this policy allows you to restrict specific role definition IDs to specific principal types, in the event you would like users to have different access to other things like Managed Identities (normally used in automation)"
  type = object({
    name                                                      = optional(string, "restrict-roles-for-non-privileged")
    management_group_id                                       = optional(string)
    deploy_assignment                                         = optional(bool, true)
    enforce                                                   = optional(bool, true)
    non_compliance_message                                    = optional(string)
    description                                               = optional(string)
    effect                                                    = optional(string, "Audit")
    non_privileged_role_definition_ids                        = optional(list(string), [])
    non_privileged_role_definition_restricted_principal_types = optional(list(string), ["User", "Group"])
  })
}

variable "policy_prefix" {
  type        = string
  description = "The prefix to apply to the custom policies"
  default     = "[CyberScot]"
}

variable "privileged_role_restriction_policy" {
  description = "Configuration for the role restriction policy, this policy allows you to restrict specific role definition IDs to specific principal types, in the event you would like users to have different access to other things like Managed Identities (normally used in automation)"
  type = object({
    name                                                  = optional(string, "restrict-roles-for-principal-type")
    management_group_id                                   = optional(string)
    deploy_assignment                                     = optional(bool, true)
    enforce                                               = optional(bool, true)
    non_compliance_message                                = optional(string)
    description                                           = optional(string)
    effect                                                = optional(string, "Audit")
    privileged_role_definition_ids                        = optional(list(string), [])
    privileged_role_definition_restricted_principal_types = optional(list(string), ["ServicePrincipal", "ManagedIdentity", "Application"])
  })
}
