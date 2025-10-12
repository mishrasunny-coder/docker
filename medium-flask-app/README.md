# Flask + Streamlit Kubernetes Application

A professional, production-ready web application featuring a Flask REST API backend with a beautiful Streamlit frontend, deployable on both Docker Compose and Kubernetes (Minikube).

## 🏗️ Architecture

```
┌─────────────────┐    HTTP     ┌─────────────────┐
│  Streamlit UI   │ ──────────► │   Flask API     │
│  (Frontend)     │             │   (Backend)     │
│  Port: 8501     │             │   Port: 5000    │
└─────────────────┘             └─────────────────┘
```

## 📁 Project Structure

```
flask-streamlit-k8s-app/
├── src/
│   ├── backend/
│   │   └── app.py                    # Flask REST API
│   └── frontend/
│       └── streamlit_app.py          # Streamlit UI
├── infrastructure/
│   ├── docker/
│   │   ├── Dockerfile                # Multi-service container
│   │   └── docker-compose.yaml       # Local development
│   └── kubernetes/
│       ├── namespace.yaml            # K8s namespace
│       ├── flask-backend.yaml        # Flask deployment
│       └── streamlit-frontend.yaml   # Streamlit deployment
├── scripts/
│   ├── deploy-minikube.sh           # Deploy to Minikube
│   ├── cleanup-minikube.sh          # Clean Minikube deployment
│   ├── start-local-access.sh        # Port forwarding setup
│   └── stop-local-access.sh         # Stop port forwarding
├── docs/
│   ├── DEPLOYMENT.md                # Detailed deployment guide
│   └── README_OLD.md                # Legacy documentation
├── pyproject.toml                   # Python dependencies
├── poetry.lock                      # Locked dependencies
├── Makefile                         # Build automation
└── .gitignore                       # Git ignore rules
```

## 🚀 Quick Start

### Prerequisites

- **Docker & Docker Compose**
- **Python 3.10+** with **Poetry**
- **Minikube & kubectl** (for Kubernetes deployment)
- **Make** (build automation)

### Installation

```bash
# Clone repository
git clone <repository-url>
cd flask-streamlit-k8s-app

# Install dependencies
make install
```

## 🐳 Docker Deployment (Recommended for Development)

### Build and Run
```bash
# Build Docker images
make setup

# Start services
make start

# View logs
docker-compose -f infrastructure/docker/docker-compose.yaml logs -f
```

### Access Applications
- **🌟 Streamlit Frontend**: http://localhost:8501
- **🔧 Flask Backend**: http://localhost:1000

### Stop Services
```bash
# Stop containers
make stop

# Full cleanup (removes images)
make clean
```

## ☸️ Kubernetes Deployment (Production-Ready)

### Deploy to Minikube
```bash
# One-command deployment
make deploy-minikube

# Set up local access (port forwarding)
make k8s-access
```

### Access Applications
- **🌟 Streamlit Frontend**: http://localhost:8501  
- **🔧 Flask Backend**: http://localhost:5000

### Management Commands
```bash
# Check deployment status
make k8s-status

# View application logs
make k8s-logs

# Stop local access
make k8s-stop-access

# Complete cleanup
make cleanup-minikube
```

## 🎯 Application Features

### Flask Backend (`/src/backend/app.py`)
- **REST API** with dynamic routing
- **Health endpoints** for monitoring
- **Environment-based configuration**
- **Production-ready** with proper error handling

**API Endpoints:**
```bash
GET  /                    # Welcome message
GET  /MyNameIs/{name}     # Personalized greeting
```

### Streamlit Frontend (`/src/frontend/streamlit_app.py`)
- **Modern web interface** with navigation
- **Real-time API integration** with Flask backend  
- **Interactive forms** and dynamic content
- **Connection status monitoring**
- **Multi-page application** with sidebar navigation

**Pages:**
- 🏠 **Home**: Connection status and overview
- 🤝 **Greeting**: Interactive name input with API calls  
- 🔧 **API Test**: Endpoint testing and debugging

## 🔧 Development

### Local Development (Poetry)
```bash
# Install dependencies
poetry install

# Run Flask backend
poetry run flask run
# Access: http://localhost:5000

# Run Streamlit frontend (separate terminal)
poetry run streamlit run src/frontend/streamlit_app.py
# Access: http://localhost:8501
```

### Environment Variables
```bash
# Flask Configuration
FLASK_APP=/app/app.py
FLASK_RUN_HOST=0.0.0.0
FLASK_RUN_PORT=5000

# Streamlit Configuration  
STREAMLIT_SERVER_PORT=8501
STREAMLIT_SERVER_HEADLESS=true
FLASK_BACKEND_URL=http://flask-backend-service:5000
```

## 📊 Production Features

### Docker
- ✅ **Multi-stage builds** for optimization
- ✅ **Poetry dependency management**
- ✅ **Environment variable configuration**
- ✅ **Volume mounting** for development

### Kubernetes
- ✅ **High availability** (2 Flask replicas)
- ✅ **Health checks** (readiness & liveness probes)
- ✅ **Resource limits** and requests
- ✅ **Service discovery** via Kubernetes DNS
- ✅ **Auto-scaling** capabilities
- ✅ **Rolling updates** support

### Monitoring & Logging
- ✅ **Application logs** via kubectl
- ✅ **Health check endpoints**
- ✅ **Connection status monitoring**
- ✅ **Deployment status tracking**

## 🧪 Testing

### Manual Testing
```bash
# Test Flask API directly
curl http://localhost:5000/
curl http://localhost:5000/MyNameIs/John

# Test via Streamlit UI
# Navigate to http://localhost:8501 and use the interface
```

### Kubernetes Testing
```bash
# Check pod health
kubectl get pods -n flask-app

# Test internal networking
kubectl exec -it deployment/streamlit-frontend -n flask-app -- \
  curl http://flask-backend-service:5000/
```

## 📚 Documentation

- **[DEPLOYMENT.md](docs/DEPLOYMENT.md)**: Comprehensive deployment guide
- **[README_OLD.md](docs/README_OLD.md)**: Legacy documentation

## 🔧 Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure ports 5000, 8501, 1000 are available
2. **Docker build fails**: Check Docker is running and has sufficient resources
3. **Minikube connection issues**: Verify Minikube is running (`minikube status`)
4. **Streamlit can't reach Flask**: Check service names and network configuration

### Debug Commands
```bash
# Docker debugging
docker ps
docker logs <container-name>

# Kubernetes debugging  
kubectl describe pods -n flask-app
kubectl logs deployment/flask-backend -n flask-app
kubectl get events -n flask-app
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Flask** - Lightweight WSGI web application framework
- **Streamlit** - Fast way to build data apps
- **Docker** - Containerization platform
- **Kubernetes** - Container orchestration
- **Poetry** - Python dependency management

---

**Built with ❤️ for production-ready deployment on Docker and Kubernetes**
