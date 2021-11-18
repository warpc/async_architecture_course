FROM ruby:2.7.4
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm
RUN npm install --global yarn

WORKDIR /app
COPY systems/event_schema_registry /event_schema_registry
COPY systems/auth/Gemfile /app/Gemfile
COPY systems/auth/Gemfile.lock /app/Gemfile.lock
RUN bundle install
