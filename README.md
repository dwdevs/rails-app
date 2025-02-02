# Ruby on Rails Application

This **Ruby on Rails -** application is architected for deployment using Docker containers, organised into distinct tiers:
  - **WEB -** NGINX is deployed as a reverse proxy, routing http://localhost requests locally to the Rails server at http://app:3000 
  - **APP -** Ruby on Rails application and server running on port :3000 and rails configuration in **/usr/src/app/**
  - **DB -** PostgreSQL Database Server with app database and rails configuration authenticted to Postgresql database
  
Docker Compose manages the deployments, volumes, and networking for this multi-container solution.

## Table of Contents ##
- [System Requirements](#system-requirements)
- [Tech Stack](#tech-stack)
- [Deploy and Manage](#deploy-and-manage)
   - [Deploy](#deploy)
   - [Manage](#manage)
   - [Deployment Details](#deployment-details)
- [Architecture](#architecture)
- [Typical Solution Workflow](#typical-solution-workflow)
- [Folder Structure](#folder-structure)

---

## System Requirements
> **To successfully run this application, you need to have the following:**
- **Git**: You should have Git installed to clone the repository and code - https://git-scm.com/downloads
- **Docker**: Docker desktop is available on Mac-os, Windows and Linux - https://docs.docker.com/desktop
---

<!-- To embed images, use a similar syntax to links but with an exclamation mark ! in front.
Example: ![Alt Text](http://example.com/image.jpg)
 -->

## Tech Stack
- **Git** - Source code and version control
- **Docker** - Used to deploy servers running on configured containers
- **Docker compose** - Managing docker deloyments, network and volumes
   - **PostgreSQL** - Database server running on container, linked with Rails application using - database.yml
   - **NGINX** - Web server running on container acting as a reverse proxy
   - **Ruby** - Application server running on container with ruby language
      - **Rails** - Web framework Ruby package with Database config - database.yml

---
&nbsp;

## Deploy and Manage

### Deploy:
```bash
   git clone git@github.com:dwdevs/ruby-on-rails.git
   cd ruby-on-rails
   cp -av sample.env .env
```
> Now set the environment variables in the .env file:
- Name of the application with - **APP_NAME=** app_name
- Version of the docker image - **IMAGE_VER=** v1.2.1
```bash
make init
```

### Open browser to - http://localhost
> NGINX will forward localhost requests to the rails server https://app:3000

&nbsp;

### Manage: 
```bash
   # Build image from dockerfile and desploy using docker compose
   make init
```
```bash
   # Build image from dockerfile from scratch no cache
   make build
```
```bash
   # Deploy the conatiners and start rails app
   make up
```   
```bash
   # Stop all the containers and remove
   make down
```
```bash
   # Restart all the containers services (Containers stay up)
   make restart
```
```bash
   # Containers down and then up - no build or image removal
   make reboot
```
```bash
   # Rebuild the images, volumes and containers and deploy
   make rebuild
```
```bash
   # Destroy everything deployed
   make destroy
```
```bash
   # View logs from the webserver container running NGINX
   make logs-web
   
   # View logs from the application container running Ruby on Rails
   make logs-app

   # View logs from the database container running PostgreSQL
   make logs-db
```
```bash
   # Show all databases on PostgreSQL server
   make show-db

   # Connect to PostgreSQL and connect to the application database
   make psql-app

   # SQL directly to the db container to show schemas on the applicaion database
   make psql-app-sql
```

&nbsp;

### Deployment details:
> **Details on how to manually install and deploy this Ruby on Rails Application:**

1. Clone the repository:
   ```bash
   git clone git@github.com:dwdevs/ruby-on-rails.git

2. Set up environment variables: Create .env file in the root of the git directory or copy sample.env:
   ```bash
   APP_NAME=your_app_name

   IMAGE_VER=1.2.1
   
   RUBY_VER=3.4.1

   POSTGRES_USER=${APP_NAME}-user
   POSTGRES_PASSWORD=enter strong password
   POSTGRES_DB=${APP_NAME}-db

3. Navigate into the project directory:
   ```bash
   cd ruby-on-rails

4. Build and Deploy the containers and applictaion:
   ```bash
   docker compose build --no-cache
   docker compose up -d --force-recreate

5. Start detachable bash session on the development APP server: **(optional)**
   ```bash
   docker compose run --rm -it app bash

6. Check that the Application can authenticate with database
   ```bash
   docker compose exec app psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}

7. View the Rails APP on your browser through NGINX proxy or local rails server on :3000
   ```bash
   open http://localhost or http://localhost:3000
---
&nbsp;

## Architecture
  - **Scalability:** Easily scale the Rails app and database independently.
  - **Security:** Nginx adds a layer of protection by hiding backend services and managing SSL. Running as a reverse proxy to route traffic to the "backend" application server - Ruby on Rails
  - **Performance:** Nginx improves performance through caching and load balancing.
  - **Portability:** Docker ensures the setup works consistently across environments.
  - **Ease of Deployment:** Docker Compose simplifies the orchestration of multiple containers.
---
&nbsp;

## Typical Solution Workflow
  1. Client Request: A user sends a request (e.g., visiting a website or calling an API endpoint http://localhost/api-endpoint)
  2. **Nginx** Reverse Proxy:
        - Receives the request
        - Forwards it to the **Rails APP** container
        - Serves static assets directly if applicable
  3. **Rails** Application:
        - Processes the request
        - Interacts with the **PostgreSQL database** to fetch or store data
        - Returns the response to **Nginx**
  4. **Nginx**: Sends the response back to the client
---
&nbsp;

## Folder Structure
> **Docker Build & Rails application configuration files**
  ```ruby
/usr/src/
      ├── /db                 # Persistent Volume - PostgreSQL data directory (pg_data)
      ├── /web                # Ephemeral Volume - NGINX server configuration file
      ├── .dockerignore       # Files and directories to exclude from the Docker build context
      ├── .env                # This contains all the environmental variables - **Sensitive data**
      ├── .gitignore          # Exclude files and directories from Git and pushed to repo         
      ├── database.yml        # Connection configuration to PostgreSQL server and database
      ├── docker-compose.yml  # Manage deployment of multiple containers with volumes and network
      ├── Dockerfile          # Steps on how to build Docker image for the Rails application
      ├── Gemfile             # Libraries for Rails web server, installed by Bundle
      ├── Gemfile.lock        # Automatically generated and locks the versions of the gems specified
      ├── Makefile            # Defines a set of deployments & tasks to be executed with easy commands 
      ├── rails-server.sh     # A Bash script for setting up a new Rails application
      ├── README.md           # You are here
      ├── sample.env          # Sample environmental config file. Shouls be .env in directory (rename)
         /app/
            ├── /app          # Main application code (Models Views Controllers)
            ├── /bin          # Executable files, including the Rails CLI
            ├── /config       # Config files including routes, database settings, and config
            ├── /db           # Contains database-related files, including migrations & seeds
            ├── /lib          # Custom libraries and modules for the application
            ├── /log          # Log files generated by the application
            ├── /public       # Static files, can be served directly by the web server like error page
            ├── /script       # Most scripts are now organised under the lib/tasks directory or handled through Rake
            ├── /storage      # Typically contains subdirectories that organise the uploaded files based on their respective identifiers
            ├── /test         # Contains test files for unit tests, integration tests and other tests
            ├── /tmp          # This is where the rails server pid is stored - ./tmp/pids/server.pid
            ├── /vendor       # This is For third-party code and libraries not managed by Bundler
            ├── Gemfile       # Specifies the gems (libraries) that the application depends on
            └── Rakefile      # Defines tasks that can be run from the command line using the rake CMD
       
  ````
