variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}

variable "region" {
  description = "Region to deploy the infrastructure"
  type        = string
}

variable "journeyly_dev_public_ssh" {
  description = "Journeyly developer public ssh key"
  type        = string
}
