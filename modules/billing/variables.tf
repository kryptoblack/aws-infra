variable "budget_subscription_emails" {
  description = "Email address to subscribe to budget notifications"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}
