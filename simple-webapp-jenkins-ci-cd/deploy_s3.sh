#!/usr/bin/env bash
# deploy_s3.sh — Deploy static site to Amazon S3 for static website hosting
# Requirements:
# - AWS CLI configured via env vars (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION)
# - S3 bucket name provided via S3_BUCKET env var
# - Bucket should have static website hosting enabled and appropriate public access via policy or CloudFront

set -euo pipefail

SITE_SRC_DIR="$(pwd)"
S3_BUCKET="${S3_BUCKET:-}"
AWS_REGION="${AWS_DEFAULT_REGION:-${AWS_REGION:-}}"

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: aws CLI not found. Install AWS CLI v2 on the Jenkins agent and ensure it's in PATH." >&2
  exit 1
fi

if [ -z "${S3_BUCKET}" ]; then
  echo "ERROR: S3_BUCKET env var is required (e.g., my-unique-site-bucket)" >&2
  exit 1
fi

if [ -z "${AWS_REGION}" ]; then
  echo "ERROR: AWS_DEFAULT_REGION or AWS_REGION must be set (e.g., us-east-1)" >&2
  exit 1
fi

# Basic validation of source files
for f in index.html styles.css script.js; do
  if [ ! -f "${SITE_SRC_DIR}/${f}" ]; then
    echo "ERROR: Missing required file: ${f}" >&2
    exit 1
  fi
done

echo "Syncing site to s3://${S3_BUCKET}/ ..."
# Note: We avoid setting ACLs here; prefer bucket policy or CloudFront for public access.
aws s3 sync "${SITE_SRC_DIR}" "s3://${S3_BUCKET}/" \
  --delete \
  --exclude ".git/*" \
  --exclude "*.sh" \
  --exclude "Dockerfile" \
  --exclude "Jenkinsfile" \
  --exclude "docker-compose.yml"

# Configure static website (index + error document)
echo "Configuring S3 static website hosting for bucket ${S3_BUCKET} ..."
aws s3 website "s3://${S3_BUCKET}" --index-document index.html --error-document index.html

# Try to print the public website endpoint (format varies by region)
# Users should verify in S3 console if unsure.
if command -v jq >/dev/null 2>&1; then
  REGION=$(aws s3api get-bucket-location --bucket "${S3_BUCKET}" | jq -r '.LocationConstraint // "us-east-1"')
else
  REGION=$(aws s3api get-bucket-location --bucket "${S3_BUCKET}" --query 'LocationConstraint' --output text)
  [ "${REGION}" = "None" ] && REGION="us-east-1"
fi

WEBSITE_ENDPOINT="http://${S3_BUCKET}.s3-website-${REGION}.amazonaws.com"
echo "Deployment complete. Website endpoint (S3 static hosting): ${WEBSITE_ENDPOINT}"
echo "Note: For HTTPS and better performance, consider putting CloudFront in front of the bucket."
