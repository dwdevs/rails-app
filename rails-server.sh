#!/bin/bash

# bundle install again and set up rails server with DB config
cd /usr/src/app
bundle install
bundle exec rails new . --force --database=postgresql
cp -av ../database.yml ./config/

# Remove any pre-existing server.pid for Rails - Fixes start-up issue with existing pid leftover
rm -f ./app/tmp/pids/server.pid

# Start rails server
bundle exec rails server -b 0.0.0.0 -p 3000