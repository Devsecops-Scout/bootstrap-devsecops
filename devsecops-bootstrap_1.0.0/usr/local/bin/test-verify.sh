#!/bin/bash
# Post-install verification for DevSecOps WSL setup

set -e

echo "🔍 Verifying Docker..."
docker --version || { echo "❌ Docker not found"; exit 1; }

echo "🔍 Verifying kubectl..."
kubectl version --client || { echo "❌ kubectl failed"; exit 1; }

echo "🔍 Verifying kind..."
kind version || { echo "❌ kind not installed"; exit 1; }

echo "🔍 Verifying ZSH..."
zsh --version || { echo "❌ ZSH not installed"; exit 1; }

echo "✅ All tools verified successfully."
exit 0
