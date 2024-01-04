provider "aws" {
  region = var.region
}


module "billing" {
    source = "./modules/billing"
    budget_subscription_emails = var.budget_subscription_emails
}

