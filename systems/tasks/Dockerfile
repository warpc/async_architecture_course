FROM ruby:2.7.4
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm
RUN npm install --global yarn

WORKDIR /app
COPY systems/tasks/Gemfile /app/Gemfile
COPY systems/tasks/Gemfile.lock /app/Gemfile.lock
RUN bundle install
