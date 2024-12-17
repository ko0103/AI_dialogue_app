FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /AI_dialogue_app

COPY Gemfile Gemfile.lock /AI_dialogue_app/

RUN bundle install

COPY . /AI_dialogue_app/