#!/bin/bash

set -e  # Exit on any error

# Step 1: Download and install Helm
echo "[*] Downloading Helm installer..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Step 2: Add Helm repositories
echo "[*] Adding Helm repositories..."
helm repo add stable https://charts.helm.sh/stable || true
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Step 3: Create Prometheus namespace
echo "[*] Creating namespace prometheus..."
kubectl create namespace prometheus || echo "Namespace already exists."

# Step 4: Install Prometheus and Grafana stack
echo "[*] Installing kube-prometheus-stack..."
helm install stable prometheus-community/kube-prometheus-stack -n prometheus

# Optional: Wait until services are created (helps avoid race conditions)
echo "[*] Waiting for services to be created..."
sleep 20

# Step 5: Patch Grafana & Prometheus services to NodePort
echo "[*] Patching Grafana service to NodePort..."
kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "NodePort"}}'

echo "[*] Patching Prometheus service to NodePort..."
kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "NodePort"}}'

# Step 6: Fetch Grafana admin password
echo "[*] Retrieving Grafana admin password..."
GRAFANA_PASSWORD=$(kubectl get secret --namespace prometheus stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)

echo "Grafana Password: $GRAFANA_PASSWORD"
