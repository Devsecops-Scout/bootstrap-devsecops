#!/bin/bash
# ------------------------------------------------------------------------
# Kubernetes CLI Installer for WSL DevSecOps
# Last Updated: 2025-07-10
# ------------------------------------------------------------------------

set -euo pipefail

# ------------------------------------------------------------------------
# 🧹 Remove broken APT repo (if exists)
# ------------------------------------------------------------------------
if [ -f /etc/apt/sources.list.d/kubernetes.list ]; then
  echo "🧹 Removing deprecated Kubernetes APT repo..."
  sudo rm -f /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
fi

# ------------------------------------------------------------------------
# 📥 Install kubectl via binary (stable release)
# ------------------------------------------------------------------------
KUBECTL_VERSION="v1.30.1"
KUBECTL_BIN="/usr/local/bin/kubectl"

if ! command -v kubectl &>/dev/null; then
  echo "⬇️ Downloading kubectl ${KUBECTL_VERSION}..."
  curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl "$KUBECTL_BIN"
  echo "✅ kubectl installed: $($KUBECTL_BIN version --client --short)"
else
  echo "✅ kubectl already installed."
fi

# ------------------------------------------------------------------------
# 🧪 Optional: Install kind (Kubernetes-in-Docker)
# ------------------------------------------------------------------------
if ! command -v kind &>/dev/null; then
  echo "⬇️ Installing kind (Kubernetes in Docker)..."
  curl -Lo kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
  chmod +x kind
  sudo mv kind /usr/local/bin/kind
  echo "✅ kind installed: $(kind version)"
else
  echo "✅ kind already installed."
fi
