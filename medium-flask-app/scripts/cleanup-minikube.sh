#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Cleaning up Flask App from Minikube${NC}"
echo "=========================================="

# Check if minikube is running
if ! minikube status &> /dev/null; then
    echo -e "${RED}❌ Minikube is not running.${NC}"
    exit 1
fi

# Delete deployments and services
echo -e "${YELLOW}🗑️  Deleting Kubernetes resources...${NC}"

kubectl delete -f infrastructure/kubernetes/streamlit-frontend.yaml --ignore-not-found=true
kubectl delete -f infrastructure/kubernetes/flask-backend.yaml --ignore-not-found=true
kubectl delete -f infrastructure/kubernetes/namespace.yaml --ignore-not-found=true

echo -e "${GREEN}✅ Cleanup complete!${NC}"
echo ""
echo -e "${BLUE}📊 Remaining resources:${NC}"
echo "======================="
kubectl get all -n flask-app 2>/dev/null || echo "No resources found in flask-app namespace (expected after cleanup)"

echo ""
echo -e "${YELLOW}💡 Optional cleanup commands:${NC}"
echo "=============================="
echo "Remove all Docker images: docker rmi \$(docker images -q)"
echo "Reset Minikube completely: minikube delete && minikube start"
