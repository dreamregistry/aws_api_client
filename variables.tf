variable "permissions" {
  type        = list(string)
  default     = []
  description = "List of permissions to grant to the user: cognito_admin"
}

variable "cognito_user_pool_id" {
  type        = string
  description = "The name of the user pool to create the app client in"
}

variable "cognito_users" {
  type = list(object({
    email = string
    name  = string
  }))
  description = "List of users to create in the user pool"
  default     = []
}

variable "export_credentials" {
  type        = bool
  description = "Whether to export the credentials of the user"
  default     = false
}
