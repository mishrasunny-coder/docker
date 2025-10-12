#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🛑 Stopping Local Access to Minikube Apps${NC}"
echo "==========================================="

# Kill port-forwarding processes
echo -e "${YELLOW}🔌 Stopping port forwarding...${NC}"
pkill -f "kubectl port-forward.*flask-app" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Port forwarding stopped successfully${NC}"
else
    echo -e "${RED}⚠️  No active port forwarding found${NC}"
fi

echo ""
echo -e "${GREEN}🎯 Local access has been stopped.${NC}"
echo "To restart access, run: ./start-local-access.sh"
