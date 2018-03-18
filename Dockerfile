FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs nodejs-legacy npm
RUN npm install -g phantomjs

COPY . /app
WORKDIR /app

RUN bundle install
RUN chmod +x docker-entrypoint.sh