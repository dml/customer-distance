FROM ruby:2.7-alpine

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

ENV BUNDLE_PATH /gems

RUN bundle install --without=development

COPY . /usr/src/app/
