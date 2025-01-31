#!/bin/bash

# Exit on any error
set -x  # Enable debugging

# Set up new Rails app
rails new . --force --database=postgresql
cp -av ./database.yml ./config/database.yml

# Remove a potentially pre-existing server.pid for Rails
# rm -f ./tmp/pids/server.pid