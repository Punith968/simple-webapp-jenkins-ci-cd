#!/usr/bin/env bash
# setup-jenkins-docker.sh — Configure Jenkins user to run Docker commands
# Run this script on the Jenkins server with sudo

set -euo pipefail

echo "Setting up Jenkins user for Docker access..."

# Add jenkins user to docker group
if id -u jenkins >/dev/null 2>&1; then
    echo "Adding jenkins user to docker group..."
    sudo usermod -aG docker jenkins
    echo "✅ Jenkins user added to docker group"
else
    echo "⚠️  Jenkins user not found. Make sure Jenkins is installed."
    exit 1
fi

# Restart Jenkins to apply group changes
echo ""
echo "To apply changes, restart Jenkins:"
echo "  sudo systemctl restart jenkins"
echo ""
echo "Or restart the Jenkins container if running in Docker:"
echo "  docker restart <jenkins-container-name>"
echo ""
echo "After restart, trigger a new build in Jenkins!"
