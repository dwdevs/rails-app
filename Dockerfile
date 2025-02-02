FROM ruby:3.4.1

# Install dependencies
RUN bash -c "apt-get update -qq \
&& apt-get install -y --no-install-recommends build-essential curl libpq-dev postgresql-client nodejs \
&& apt-get clean"

# Set the working directory and copy files & Gemfile for packages into container
WORKDIR /usr/src/

# # Install & Copy the Gemfile and Gemfile.lock
COPY Gemfile* .
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose the Rails server port
EXPOSE 3000

# Command to run the Rails server using bundle
CMD ["/bin/sh", "-c", "bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]