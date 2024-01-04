# aws1-infrastructure

AWS entirely managed by Terraform

## Prerequisites

1. You should have `access` and `secret` key of an AWS user with 
Administrator Access (For Ease).
2. Terraform should be able to access your AWS Access and AWS Secret keys. You 
can checkout the [docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) 
on how you can do it.

## Usage

Create a `terraform.tfvars` or `terraform.tfvars.json` file and populate the 
variables.

```hcl
budget_subscription_emails = ["aws1@pratikthakare.com"]
region                     = ap-south-1
```
or
```json
{
    "budget_subscription_emails": ["aws1@pratikthakare.com"],
    "region": "ap-south-1"
}
```

You can check the `variables.tf` file to figure out which variables are 
optional and which of them aren't.

### Init

```bash
terraform init
```

### Plan

```bash
mkdir plans
terraform plan -out "plans/init.tfplan"
```

Review the plan and decide if that is the configuration you want to apply. If 
yes, then move to `apply` stage.

### Apply

```bash
terraform apply "plans/init.tfplan"
```
