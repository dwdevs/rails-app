# Ruby on Rails Application

This **Ruby on Rails** application is deployed using Docker containers split across isolated tiers {WEB, APP, DB} - Docker compose manages the deployments, volumes and networks.
The full Configuration details and deployment instructions are below.

## Table of Contents
- [System Requirements](#system-requirements)
- [Tech Stack](#tech-stack)
- [Deploy and Manage](#deploy-and-manage)
   - [Deploy](#deploy)
   - [Manage](#manage)
- [Installation Details](#installation-details)
- [Architecture](#architecture)
- [Typical Solution Workflow](#typical-solution-workflow)
- [Folder Structure](#folder-structure)
---
&nbsp;

## System Requirements
To successfully run this application, you need to have the following:
- Git: You should have Git installed to clone the repository and code - https://git-scm.com/downloads
- Docker: Windows, Mac-os and Linux Docker desktop is available - https://docs.docker.com/desktop
---
&nbsp;

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
   git clone git@github.com:dwdevs/rails-app.git
   cd rails-app
   cp -av sample.env .env
   make init
```
### Open browser to - http://localhost:3000
&nbsp;

### Manage: 
```bash
   # Deploy the conatiners and start rails app
   make up
```   
```bash
   # Stop all the containers and remove
   make down
```
```bash
   # Restart all the containers
   make restart
```
```bash
   # Remove everything then rebuild and deploy
   make reboot
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
```
```bash
   # Connect to PostgreSQL and connect to the application database
   make psql-app
```
```bash
   # SQL directly to show schemas on the applicaion database
   make psql-app-sql
```
---
&nbsp;

## Installation Details
Details on how to manually install and deploy this Ruby on Rails Application:

1. Clone the repository:
   ```bash
   git clone git@github.com:dwdevs/rails-app.git 

2. Set up environment variables: Create .env file in the root of the git directory or copy sample.env:
   ```bash
   APP_NAME=your_app_name
   POSTGRES_DB=${APP_NAME}-db
   POSTGRES_USERNAME=${APP_NAME}-user
   POSTGRES_PASSWORD="enter strong password"

3. Navigate into the project directory:
   ```bash
   cd rails-app

4. Build and Deploy the containers and applictaion:
   ```bash
   docker compose build --no-cache
	docker compose up -d --force-recreate

5. Start detachable bash session on the development APP server: (optional)
   ```bash
   docker compose run --rm -it app bash

6. Check that the Application can authenticate with database
   ```bash
   docker compose exec app psql -U ${POSTGRES_USERNAME} -d ${POSTGRES_DB}

7. View the Rails APP on your browser 
   ```bash
   open http://localhost:3000
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
  1. Client Request: A user sends a request (e.g., visiting a website or calling an API endpoint http://localhost:3000/api-endpoint)
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
**Docker Build & Rails application configuration files**
  ```ruby
/usr/src/app/
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
    ├── railsinit.sh        # A Bash script for setting up a new Rails application
    ├── README.md           # You are here
    ├── sample.env          # Sample environmental config file. Shouls be .env in directory (rename)
        /rails-app/
        ├── /app            # Main application code (Models Views Controllers)
        ├── /bin            # Executable files, including the Rails CLI
        ├── /config         # Config files including routes, database settings, and config
        ├── /db             # Contains database-related files, including migrations & seeds
        ├── /lib            # Custom libraries and modules for the application
        ├── /log            # Log files generated by the application
        ├── /public         # Static files, can be served directly by the web server like error page
        ├── /test           # Contains test files for unit tests, integration tests and other tests
        ├── /vendor         # This is For third-party code and libraries not managed by Bundler
        ├── Gemfile         # Specifies the gems (libraries) that the application depends on
        └── Rakefile        # Defines tasks that can be run from the command line using the rake CMD
       
  ````
