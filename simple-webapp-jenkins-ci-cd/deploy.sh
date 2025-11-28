#!/usr/bin/env bash
# deploy.sh — user-space deployment: copies site files to $HOME/published_site
# and serves them via a background Python HTTP server on WEBAPP_PORT (default 8090).

set -euo pipefail

SITE_SRC_DIR="$(pwd)"
TARGET_DIR="${HOME}/published_site"
PORT="${WEBAPP_PORT:-8090}"

# Prefer systemd-managed services if available
# No root-restart logic needed for user-space serving

# Validate files before copying
if [ ! -f "${SITE_SRC_DIR}/index.html" ] || [ ! -f "${SITE_SRC_DIR}/styles.css" ] || [ ! -f "${SITE_SRC_DIR}/script.js" ]; then
  echo "Required files missing. Run ./validate.sh to see details."
  exit 1
fi

echo "Deploying to user space directory ${TARGET_DIR}..."
mkdir -p "${TARGET_DIR}"
cp -r "${SITE_SRC_DIR}"/* "${TARGET_DIR}/"

# Stop any existing Python server on the port
if pgrep -f "python3 -m http.server ${PORT}" >/dev/null 2>&1; then
  echo "Stopping previous python server on port ${PORT}"
  pkill -f "python3 -m http.server ${PORT}" || true
fi

echo "Starting python server on port ${PORT} serving ${TARGET_DIR}..."
nohup python3 -m http.server "${PORT}" --directory "${TARGET_DIR}" >/dev/null 2>&1 &

echo "Deployment complete. Access the site at http://localhost:${PORT}" 
