#!/bin/bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying Flask App to Minikube${NC}"
echo "============================================"

# Check if minikube is running
echo -e "${YELLOW}📋 Checking Minikube status...${NC}"
if ! minikube status &> /dev/null; then
    echo -e "${RED}❌ Minikube is not running. Please start it with: minikube start${NC}"
    exit 1
fi

# Set Docker environment to use Minikube's Docker daemon
echo -e "${YELLOW}🔧 Configuring Docker environment for Minikube...${NC}"
eval $(minikube -p minikube docker-env)

# Build the Docker images using Minikube's Docker daemon
echo -e "${YELLOW}🏗️  Building Docker images in Minikube...${NC}"
cd infrastructure/docker && docker-compose build && cd ../..

# Deploy to Kubernetes
echo -e "${YELLOW}🚢 Deploying to Kubernetes...${NC}"

# Apply namespace
kubectl apply -f infrastructure/kubernetes/namespace.yaml

# Apply deployments and services
kubectl apply -f infrastructure/kubernetes/flask-backend.yaml
kubectl apply -f infrastructure/kubernetes/streamlit-frontend.yaml

# Wait for deployments to be ready
echo -e "${YELLOW}⏳ Waiting for deployments to be ready...${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/flask-backend -n flask-app
kubectl wait --for=condition=available --timeout=300s deployment/streamlit-frontend -n flask-app

# Get service URLs
echo -e "${GREEN}✅ Deployment successful!${NC}"
echo ""
echo -e "${BLUE}📊 Service Information:${NC}"
echo "======================="

# Get Minikube IP
MINIKUBE_IP=$(minikube ip)

echo -e "${GREEN}Flask Backend:${NC}    http://${MINIKUBE_IP}:30001"
echo -e "${GREEN}Streamlit Frontend:${NC} http://${MINIKUBE_IP}:30002"
echo ""

echo -e "${BLUE}🔍 Useful Commands:${NC}"
echo "===================="
echo "View pods:           kubectl get pods -n flask-app"
echo "View services:       kubectl get services -n flask-app"
echo "View logs (Flask):   kubectl logs -f deployment/flask-backend -n flask-app"
echo "View logs (Frontend): kubectl logs -f deployment/streamlit-frontend -n flask-app"
echo "Open Frontend:       minikube service streamlit-frontend-service -n flask-app"
echo "Open Backend:        minikube service flask-backend-service -n flask-app"
echo ""

echo -e "${YELLOW}🌐 Opening services in browser...${NC}"
echo "Press Ctrl+C to stop port forwarding when done."
echo ""

# Optional: Open services in browser
# Uncomment the lines below if you want automatic browser opening
# minikube service streamlit-frontend-service -n flask-app &
# minikube service flask-backend-service -n flask-app &

echo -e "${GREEN}🎉 Deployment complete! Your app is running on Minikube.${NC}"
