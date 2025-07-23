variable "region" {
  description = "Region to deploy the infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "budget_subscription_emails" {
  description = "Email address to subscribe to budget notifications"
  type        = list(string)
}

variable "journeyly_dev_public_ssh" {
  description = "Journeyly developer public ssh key"
  type        = string
}
