# Makefile

.PHONY: setup start stop clean

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
