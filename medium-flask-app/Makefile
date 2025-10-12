# Makefile

.PHONY: setup start stop clean deploy-minikube cleanup-minikube k8s-logs k8s-status k8s-access k8s-stop-access

# Install Poetry and its dependencies
install:
	@echo "Installing Poetry..."
	curl -sSL https://install.python-poetry.org | python -
	@echo "Installing dependencies with Poetry..."
	poetry install


setup:
	docker-compose build

start:
	docker-compose up -d

stop:
	docker-compose down

clean:
	docker-compose down --rmi all -v --remove-orphans

# Minikube deployment targets
deploy-minikube:
	@echo "Deploying to Minikube..."
	./deploy-minikube.sh

cleanup-minikube:
	@echo "Cleaning up Minikube deployment..."
	./cleanup-minikube.sh

k8s-status:
	@echo "Checking Kubernetes status..."
	kubectl get all -n flask-app

k8s-logs:
	@echo "Flask Backend logs:"
	kubectl logs -f deployment/flask-backend -n flask-app --tail=50 &
	@echo "Streamlit Frontend logs:"
	kubectl logs -f deployment/streamlit-frontend -n flask-app --tail=50

k8s-access:
	@echo "Starting local access to Kubernetes apps..."
	./start-local-access.sh

k8s-stop-access:
	@echo "Stopping local access to Kubernetes apps..."
	./stop-local-access.sh
