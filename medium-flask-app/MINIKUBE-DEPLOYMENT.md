# 🚀 Minikube Deployment Guide

This guide explains how to deploy your Flask app with Streamlit frontend to Minikube (local Kubernetes cluster).

## 📋 Prerequisites

### Required Software
- **Minikube**: Local Kubernetes cluster
- **kubectl**: Kubernetes command-line tool  
- **Docker**: Container runtime (used by Minikube)
- **Make**: Build automation (for simplified commands)

### Installation Commands

```bash
# Install Minikube (macOS with Homebrew)
brew install minikube

# Install kubectl (if not already installed)
brew install kubectl

# Start Minikube
minikube start

# Verify installation
minikube status
kubectl cluster-info
```

## 🏗️ Architecture

The application consists of two main components deployed in Kubernetes:

### Components
- **Flask Backend** (`flask-backend`): REST API server on port 5000
- **Streamlit Frontend** (`streamlit-frontend`): Web UI on port 8501

### Kubernetes Resources
- **Namespace**: `flask-app` (isolates resources)
- **Deployments**: Manage pod replicas and updates
- **Services**: Expose applications via NodePort (external access)
- **ConfigMaps/Secrets**: Environment configuration

### Network Architecture
```
Internet/Browser
     ↓
[Minikube IP:30002] ← Streamlit Frontend (NodePort)
     ↓
[flask-backend-service:5000] ← Internal communication
     ↓
[Flask Backend Pods] ← Multiple replicas for availability
```

## 🚀 Quick Start

### 1. Deploy to Minikube
```bash
# One-command deployment
make deploy-minikube

# Or manually:
./deploy-minikube.sh
```

### 2. Access Your Application
```bash
# Get Minikube IP
minikube ip

# Access services
# Frontend: http://[MINIKUBE_IP]:30002
# Backend:  http://[MINIKUBE_IP]:30001
```

### 3. Open in Browser (Alternative)
```bash
# Open frontend automatically
minikube service streamlit-frontend-service -n flask-app

# Open backend API
minikube service flask-backend-service -n flask-app
```

## 📊 Management Commands

### Status and Monitoring
```bash
# Check deployment status
make k8s-status

# View all resources
kubectl get all -n flask-app

# Check pod details
kubectl describe pods -n flask-app

# View events
kubectl get events -n flask-app --sort-by=.metadata.creationTimestamp
```

### Logs and Debugging
```bash
# View logs (combined)
make k8s-logs

# View Flask logs only
kubectl logs -f deployment/flask-backend -n flask-app

# View Streamlit logs only  
kubectl logs -f deployment/streamlit-frontend -n flask-app

# View logs from specific pod
kubectl logs -f <pod-name> -n flask-app
```

### Scaling and Updates
```bash
# Scale Flask backend
kubectl scale deployment flask-backend --replicas=3 -n flask-app

# Update image (after rebuilding)
kubectl set image deployment/flask-backend flask-app=medium-flask-app-my-testing-app:latest -n flask-app

# Restart deployments
kubectl rollout restart deployment/flask-backend -n flask-app
kubectl rollout restart deployment/streamlit-frontend -n flask-app
```

## 🧹 Cleanup

```bash
# Remove deployment
make cleanup-minikube

# Or manually:
./cleanup-minikube.sh

# Complete Minikube reset (if needed)
minikube delete
minikube start
```

## 🔧 Configuration Details

### Environment Variables
- **Flask Backend**:
  - `FLASK_APP`: `/app/app.py`
  - `FLASK_RUN_HOST`: `0.0.0.0`
  - `FLASK_RUN_PORT`: `5000`

- **Streamlit Frontend**:
  - `STREAMLIT_SERVER_PORT`: `8501`
  - `STREAMLIT_SERVER_HEADLESS`: `true`
  - `FLASK_BACKEND_URL`: `http://flask-backend-service:5000`

### Resource Limits
- **Flask Backend**: 128Mi-256Mi RAM, 100m-200m CPU
- **Streamlit Frontend**: 256Mi-512Mi RAM, 100m-300m CPU

### Health Checks
- **Readiness Probes**: Ensure pods are ready before receiving traffic
- **Liveness Probes**: Restart unhealthy pods automatically

## 🐛 Troubleshooting

### Common Issues

#### 1. Images Not Found
```bash
# Ensure you're using Minikube's Docker daemon
eval $(minikube -p minikube docker-env)

# Rebuild images
make setup
```

#### 2. Services Not Accessible
```bash
# Check service status
kubectl get services -n flask-app

# Verify NodePort configuration
minikube service list
```

#### 3. Pods Not Starting
```bash
# Check pod status
kubectl describe pods -n flask-app

# Check events for errors
kubectl get events -n flask-app
```

#### 4. Frontend Can't Connect to Backend
```bash
# Check if backend service is running
kubectl get endpoints flask-backend-service -n flask-app

# Verify service discovery
kubectl exec -it deployment/streamlit-frontend -n flask-app -- nslookup flask-backend-service
```

### Logs Analysis
```bash
# Application startup issues
kubectl logs deployment/flask-backend -n flask-app --previous

# Resource issues
kubectl top pods -n flask-app

# Network connectivity
kubectl exec -it deployment/streamlit-frontend -n flask-app -- wget -qO- http://flask-backend-service:5000/
```

## 📁 File Structure

```
k8s/
├── namespace.yaml              # Namespace definition
├── flask-backend.yaml         # Backend deployment + service
└── streamlit-frontend.yaml    # Frontend deployment + service

deploy-minikube.sh             # Deployment script
cleanup-minikube.sh            # Cleanup script
MINIKUBE-DEPLOYMENT.md         # This documentation
Makefile                       # Build automation
```

## 🔄 Development Workflow

### 1. Code Changes
```bash
# 1. Make code changes
# 2. Rebuild images
make setup

# 3. Update Kubernetes deployment
kubectl rollout restart deployment/flask-backend -n flask-app
kubectl rollout restart deployment/streamlit-frontend -n flask-app
```

### 2. Configuration Changes
```bash
# Edit Kubernetes manifests
vim k8s/flask-backend.yaml

# Apply changes
kubectl apply -f k8s/flask-backend.yaml
```

### 3. Testing
```bash
# Port forward for local testing
kubectl port-forward service/flask-backend-service 5000:5000 -n flask-app &
kubectl port-forward service/streamlit-frontend-service 8501:8501 -n flask-app &

# Test locally
curl http://localhost:5000/
open http://localhost:8501
```

## 🎯 Next Steps

- **Ingress**: Set up ingress controller for better routing
- **Persistence**: Add persistent volumes for data storage
- **Monitoring**: Implement Prometheus/Grafana monitoring
- **CI/CD**: Automate deployments with GitHub Actions
- **Production**: Deploy to managed Kubernetes (EKS, GKE, AKS)

## 📚 Additional Resources

- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubectl Reference](https://kubernetes.io/docs/reference/kubectl/)
- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Service Types](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)
