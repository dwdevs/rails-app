# Ruby on Rails Application

This **Ruby on Rails**! application is deployed using Docker containers split across isolated tiers {WEB, APP, DB} - Docker compose manages the deployments, volumes and networks.
The full Configuration details and deployment instructions are below.

## Table of Contents
- [Quick deploy](#quick-deploy)
- [Tech Stack](#tech-stack)
- [System requirements](system-requirements)
- [Installation](#installation)
- [Architecture](#architecture)
- [Typical Workflow](#typical-workflow)
- [Folder Structure](#folder-structure)

## Quick Deploy
```bash
   git clone git@github.com:dwdevs/rails-app.git
   cd rails-app
   cp -av sample.env .env
   make init
```

## Tech Stack
- **Git**: Source code and version control to GitHub
- **Docker**: Servers running on configured containers
- **Docker compose**: Managing docker deloyments, network and volumes
- **PostgreSQL**: Database server linked with Rail application using - database.yml
- **NGINX**: Webs server acting as a reverse proxy, serving requests to backend servers
- **Ruby**: Application server - Linux container built 
- **Rails**: web framework package with other supporting gems defined in Gemfile


## System requirements
To successfully run this application, you need to have the following system dependencies installed:
- Docker - Windows, Mac-os and Linux Docker desktop is available - https://docs.docker.com/desktop
    - Creating and managing containers that encapsulate the application and its environment.

- Git: You should have Git installed to clone the repository and code - https://git-scm.com/downloads


## Installation
To install and deploy this Ruby on Rails Application, follow these steps:

1. Clone the repository:
   ```bash
   git clone 

2. Navigate to the project directory:
   ```bash
   cd rails-app

3. Set up environment variables: Create .env file in the root of the git directory or copy sample.env:
   ```bash
   APP_NAME=your_app_name
   POSTGRES_DB=${APP_NAME}-db
   POSTGRES_USERNAME=${APP_NAME}-user
   POSTGRES_PASSWORD="enter strong password"

4. Build and Deploy the containers and applictaion:
   ```bash
   make init

5. Start detachable bash session on the development APP server: (optional)
   ```bash
   make bash

6. View the Rails APP on your browser 
   ```bash
   open http://localhost:3000


## Architecture
  - **Scalability:** Easily scale the Rails app and database independently.
  - **Security:** Nginx adds a layer of protection by hiding backend services and managing SSL.
  - **Performance:** Nginx improves performance through caching and load balancing.
  - **Portability:** Docker ensures the setup works consistently across environments.
  - **Ease of Deployment:** Docker Compose simplifies the orchestration of multiple containers.


## Typical Workflow
  1. Client Request: A user sends a request (e.g., visiting a website or calling an API endpoint)
  2. **Nginx** Reverse Proxy:
        - Receives the request
        - Forwards it to the **Rails app** container
        - Serves static assets directly if applicable
  3. **Rails** Application:
    - Processes the request
    - Interacts with the **PostgreSQL database** to fetch or store data
    - Returns the response to **Nginx**
  4. **Nginx**: Sends the response back to the client


## Folder Structure
**Docker Build & Rails application configuration files**
  ```ruby
/usr/src/app/
    ├── /db                 # Persistent volume - PostgreSQL data directory (pg_data)
    ├── /web                # Volume - NGINX server configuration file
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
