FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs nodejs-legacy npm
RUN npm install -g phantomjs

COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN bundle install

COPY . /app
RUN rm -f tmp/pids/server.pid