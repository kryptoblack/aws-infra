#!/bin/bash

set -euo pipefail

# Check for required argument
if [ $# -ne 2 ]; then
  echo "Usage: $0 <aws-profile-name> <role-arn>"
  exit 1
fi

PROFILE_NAME="$1"
ROLE_ARN="$2"
SESSION_NAME="session-${PROFILE_NAME}-$(date +%s)"

# Assume the role
ASSUME_ROLE_OUTPUT=$(aws sts assume-role \
  --role-arn "$ROLE_ARN" \
  --role-session-name "$SESSION_NAME" \
  --output json)

# Extract values using jq
AWS_ACCESS_KEY_ID=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.SessionToken')

# Write to ~/.aws/credentials using AWS CLI-compatible format
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile "$PROFILE_NAME"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile "$PROFILE_NAME"
aws configure set aws_session_token "$AWS_SESSION_TOKEN" --profile "$PROFILE_NAME"

echo "Temporary credentials set under profile [$PROFILE_NAME]"
