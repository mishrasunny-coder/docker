# Makefile

.PHONY: setup start stop clean

setup:
	docker-compose build

start:
	docker-compose up -d

stop:
	docker-compose down

clean:
	docker-compose down --rmi all -v --remove-orphans
