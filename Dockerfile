FROM ruby:2.7-buster

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

ENV BUNDLE_PATH /gems

RUN bundle install

COPY . /usr/src/app/

RUN ["echo", "hello world"]
