variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "aws_account_id" {
  type    = string
  default = "197720242153"
}

variable "project_name" {
  type    = string
  default = "devsecops-selfbuild"
  validation {
    condition     = var.project_name == "devsecops-selfbuild"
    error_message = "The bootstrap permissions are scoped to devsecops-selfbuild."
  }
}

variable "image_ref" {
  type        = string
  description = "Previously scanned, signed and verified ECR image by digest."
  validation {
    condition     = can(regex("@sha256:[0-9a-f]{64}$", var.image_ref))
    error_message = "Deploy an immutable image digest, not a moving tag."
  }
}

variable "app_version" {
  type    = string
  default = "local"
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "allowed_cidr" {
  type        = string
  sensitive   = true
  description = "One trusted public IPv4 address as a /32; never the whole internet."
  validation {
    condition     = can(cidrnetmask(var.allowed_cidr)) && endswith(var.allowed_cidr, "/32")
    error_message = "Use one public IPv4 /32 CIDR."
  }
}
