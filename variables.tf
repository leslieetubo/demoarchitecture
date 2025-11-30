variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {
    Project = "Cloudpad"
    ManagedBy = "Terraform"
  }
}