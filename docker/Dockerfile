FROM ruby:2.5

# Create app folder in container (working dir)
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy all app files to app folder in container
COPY ./app/* /usr/src/app/

# Install ruby gems in container
RUN bundle install

# Define default container command
ENTRYPOINT /usr/src/app/entrypoint.sh

# Expose requests logger port
EXPOSE 4567
