# Billings

If you are working on an account with Free Tier or without one, you should have
budgets setup so you can be aware of the cost you are incurring.

Note: Each report through AWS Budget cost you around $0.01. It is still better 
than costing you $10, so don't be so frugal.


### Validate

Use the below snippet to review the budgets.

```bash
# Copy the Account ID
aws sts get-caller-identity
aws budgets describe-budgets --account-id <ACCOUNT_ID> | jq ".Budgets[].BudgetName"
```
