# Define the default service name
APP_NAME=

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make init       - The first command to run new directory Build Docker images and deploy"
	@echo "  make build      - Build the Docker images"
	@echo "  make up         - Deploy containers without forcing build"
	@echo "  make down       - Stop, remove containers, orphans and local images built"
	@echo "  make restart    - Restart WEB, APP, DB - no changes reflected"
	@echo "  make reboot     - Reboot, down first then up but with build for changes"
	@echo "  make shutdown   - Shutdown removing all containers, images and volumes"
	@echo "  make bash       - Open a bash shell in the app container and remove on exit"
	@echo "  make logs       - View logs from the app container"
	@echo "  make psql       - Connect to the PostgreSQL and Postgres database"
	@echo "  make psql-app   - Connect directly to the APP database and list schemas"

.PHONY: nuke
nuke:
	docker compose down --remove-orphans --rmi all --volumes
	docker compose rm -f
	docker system prune -a -f

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
	docker compose down --remove-orphans --rmi local

# Restart the app container
.PHONY: restart
restart:
	docker compose restart

# Reboot - docker-compose down and up
.PHONY: reboot
reboot:
	docker compose down --remove-orphans --rmi local
	docker compose up -d --force-recreate --build

# This needs to changing to destroy - Remove everything deployed
.PHONY: shutdown
shutdown:
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
	docker compose exec db psql -U username -d postgres -c '\l' 

# Connect to the DB directly
.PHONY: psql-app
psql-app:
	docker compose exec db psql -U username -d postgres 

.PHONY: psql-app-sql
psql-app-sql:
	docker compose exec db psql -U username -d ${APP_NAME}-db -c "SELECT schema_name FROM information_schema.schemata;"