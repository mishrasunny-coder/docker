#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Local Access to Minikube Apps${NC}"
echo "=========================================="

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed or not in PATH"
    exit 1
fi

# Check if pods are running
echo -e "${YELLOW}📋 Checking pod status...${NC}"
kubectl get pods -n flask-app

# Kill any existing port-forwarding processes
echo -e "${YELLOW}🧹 Cleaning up existing port forwards...${NC}"
pkill -f "kubectl port-forward.*flask-app" 2>/dev/null || true

# Start port forwarding for both services
echo -e "${YELLOW}🔌 Setting up port forwarding...${NC}"

# Flask Backend
kubectl port-forward service/flask-backend-service 5000:5000 -n flask-app > /dev/null 2>&1 &
FLASK_PID=$!

# Streamlit Frontend  
kubectl port-forward service/streamlit-frontend-service 8501:8501 -n flask-app > /dev/null 2>&1 &
STREAMLIT_PID=$!

# Wait a moment for ports to be ready
sleep 3

# Test connections
echo -e "${YELLOW}🧪 Testing connections...${NC}"

if curl -s http://localhost:5000/ > /dev/null; then
    echo -e "${GREEN}✅ Flask Backend: http://localhost:5000${NC}"
else
    echo "❌ Flask Backend: Not accessible"
fi

if curl -s -I http://localhost:8501/ > /dev/null; then
    echo -e "${GREEN}✅ Streamlit Frontend: http://localhost:8501${NC}"
else
    echo "❌ Streamlit Frontend: Not accessible"
fi

echo ""
echo -e "${BLUE}📱 Access Your Application:${NC}"
echo "=========================="
echo -e "${GREEN}🌟 Main App (Streamlit): http://localhost:8501${NC}"
echo -e "${GREEN}🔧 API Backend (Flask):  http://localhost:5000${NC}"
echo ""
echo -e "${YELLOW}💡 Useful API endpoints:${NC}"
echo "• GET  http://localhost:5000/"
echo "• GET  http://localhost:5000/MyNameIs/YourName"
echo ""
echo -e "${YELLOW}🛑 To stop port forwarding:${NC}"
echo "   kill $FLASK_PID $STREAMLIT_PID"
echo "   Or: pkill -f 'kubectl port-forward.*flask-app'"
echo ""
echo -e "${GREEN}🎉 Your app is ready! Open http://localhost:8501 in your browser.${NC}"

# Optional: Open browser automatically (uncomment if desired)
# open http://localhost:8501  # macOS
# xdg-open http://localhost:8501  # Linux
