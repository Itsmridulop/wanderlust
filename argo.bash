#!/bin/bash

set -e
set -o pipefail

# --- Function to handle errors gracefully ---
handle_error() {
    echo "❌ Error occurred in script at line: $1"
    exit 1
}
trap 'handle_error $LINENO' ERR

echo "📁 Creating 'argocd' namespace if it doesn't exist..."
kubectl get ns argocd >/dev/null 2>&1 || kubectl create namespace argocd

echo "⬇️ Installing ArgoCD (stable release)..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "🔁 Patching 'argocd-server' service to NodePort..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

echo "🚪 Forwarding ArgoCD UI port 8000 -> 443..."
kubectl port-forward svc/argocd-server -n argocd 8000:443 & disown

# Give port-forwarding time to establish
sleep 5

echo "🔐 Fetching initial admin password..."
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

if [[ -z "$ARGOCD_PASSWORD" ]]; then
    echo "❌ Failed to fetch ArgoCD admin password."
    exit 1
fi

echo "✅ ArgoCD Admin Password: $ARGOCD_PASSWORD"

echo "🔐 Logging in to ArgoCD..."
argocd login localhost:8000 --username admin --password "$ARGOCD_PASSWORD" --insecure

# --- User input for cluster context ---
read -p "🌐 Enter your cluster context name (e.g., kind-wanderlust-cluster): " CLUSTER_CONTEXT
CLUSTER_CONTEXT=${CLUSTER_CONTEXT:-kind-wanderlust-cluster} # default

echo "📌 Adding cluster '$CLUSTER_CONTEXT' to ArgoCD with name 'wanderlust'..."
argocd cluster add "$CLUSTER_CONTEXT" --name wanderlust --in-cluster

echo "🎉 ArgoCD setup completed successfully!"
