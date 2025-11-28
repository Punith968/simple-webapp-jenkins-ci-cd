#!/usr/bin/env bash
# deploy.sh — simple deployment script that copies site files to /var/www/html
# Usage: sudo ./deploy.sh

set -euo pipefail

# Directory containing site files (assumes script is run from project root)
SITE_SRC_DIR="$(pwd)"
TARGET_DIR="/var/www/html"

# Prefer systemd-managed services if available
restart_service() {
  if command -v systemctl >/dev/null 2>&1; then
    if systemctl list-units --type=service | grep -q nginx; then
      echo "Restarting nginx via systemctl"
      sudo systemctl restart nginx
      return 0
    elif systemctl list-units --type=service | grep -q apache2; then
      echo "Restarting apache2 via systemctl"
      sudo systemctl restart apache2
      return 0
    fi
  fi

  # Fallbacks
  if command -v service >/dev/null 2>&1; then
    sudo service nginx restart || sudo service apache2 restart || true
  fi
}

# Validate files before copying
if [ ! -f "${SITE_SRC_DIR}/index.html" ] || [ ! -f "${SITE_SRC_DIR}/styles.css" ] || [ ! -f "${SITE_SRC_DIR}/script.js" ]; then
  echo "Required files missing. Run ./validate.sh to see details."
  exit 1
fi

# Create target dir if missing and copy files
echo "Deploying files to ${TARGET_DIR}..."
mkdir -p "${TARGET_DIR}"
cp -r "${SITE_SRC_DIR}"/* "${TARGET_DIR}/"

# Ensure proper ownership (www-data common, fallback to nobody)
if id -u www-data >/dev/null 2>&1; then
  echo "Setting ownership to www-data"
  chown -R www-data:www-data "${TARGET_DIR}" 2>/dev/null || true
else
  echo "Setting ownership to nobody:nogroup"
  chown -R nobody:nogroup "${TARGET_DIR}" 2>/dev/null || true
fi

sudo -n systemctl restart nginx 2>/dev/null || sudo -n service nginx restart 2>/dev/null || true
restart_service

echo "Deployment complete. Files copied to ${TARGET_DIR}."
