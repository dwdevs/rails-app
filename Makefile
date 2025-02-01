include .env
export $(shell sed 's/=.*//' .env)

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make init         -  Build image from dockerfile and desploy using docker compose"
	@echo "  make build        -  Build image from dockerfile from scratch no cache"
	@echo "  make up           -  Deploy the conatiners and start rails app"
	@echo "  make down         -  Stop all the containers and remove"
	@echo "  make restart      -  Restart all the containers"
	@echo "  make reboot       -  Remove everything then rebuild and deploy"
	@echo "  make destroy      -  Destroy everything deployed"
	@echo "  make bash         -  Open a bash shell in the app container and remove on exit"
	@echo "  make log-web      -  View logs from the webserver container running NGINX"
	@echo "  make logs-app     -  View logs from the application container running Ruby on Rails"
	@echo "  make logs-db      -  View logs from the database container running PostgreSQL"
	@echo "  make show-db      -  Show all databases on PostgreSQL server"
	@echo "  make psql-app     -  Connect to PostgreSQL and connect to the application database"
	@echo "  make psql-app-sql -  SQL directly to show schemas on the applicaion database"
	
# Set up a fresh Rails app and then build into the image to deploy from
.PHONY: init
init:
	docker compose build --no-cache
	docker compose up -d --force-recreate

# Build the Docker images
.PHONY: build
build:
	docker compose build --no-cache

# Deploy the conatiners and start APP
.PHONY: up
up:
	docker compose up -d --force-recreate

# Stop the containers
.PHONY: down
down:
	docker compose down

# Restart the app container
.PHONY: restart
restart:
	docker compose restart

# Reboot - docker-compose down and up
.PHONY: reboot
reboot:
	docker compose down --remove-orphans
	docker compose up -d --force-recreate --build

# This needs to changing to destroy - Remove everything deployed
.PHONY: destroy
destroy:
	docker compose down --rmi all --volumes

# Open a bash shell in the app container
.PHONY: bash
bash:
	docker compose run --rm -it app bash

# View logs from the web container
.PHONY: logs-web
logs-web:
	docker compose logs -f web

# View logs from the app container
.PHONY: logs-app
logs-app:
	docker compose logs -f app

# View logs from the db container
.PHONY: logs-db
logs-db:
	docker compose logs -f db

# Show all databases on PostgreSQL server
.PHONY: show-db
show-db:
	docker compose exec db psql -U ${PGUSER} -d ${PGDATABASE} -c '\l' 

# Connect to PostgreSQL and connect to the application database
.PHONY: psql-app
psql-app:
	docker compose exec db psql -U ${PGUSER} -d ${PGDATABASE} 

# SQL directly to db container to show schemas on the applicaion database
.PHONY: psql-app-sql
psql-app-sql:
	docker compose exec db psql -U ${PGUSER} -d ${PGDATABASE} -c "SELECT schema_name FROM information_schema.schemata;"
