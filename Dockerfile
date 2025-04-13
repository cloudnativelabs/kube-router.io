# Make Ruby version configurable
ARG RUBY_VERSION=3.3

# Use the official Ruby image as the base
FROM ruby:${RUBY_VERSION}-slim

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /srv/jekyll

# Install Jekyll and Bundler
RUN gem install bundler jekyll

# Copy the Gemfile and Gemfile.lock (if they exist)
COPY Gemfile* ./

# Install dependencies
RUN bundle install

# Expose the port Jekyll runs on
EXPOSE 4000
