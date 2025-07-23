locals {
  common_tags = {
    ManagedBy = "Terraform"
  }
}

# module "billing" {
#   source                     = "./modules/billing"
#   budget_subscription_emails = var.budget_subscription_emails
#   common_tags                = local.common_tags
# }
#
# module "iam" {
#   source                     = "./modules/iam"
#   common_tags                = local.common_tags
# }

module "journeyly" {
  source      = "./modules/journeyly"
  common_tags = local.common_tags
}
