FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential nodejs
RUN mkdir /question_box
WORKDIR /question_box
COPY Gemfile /question_box/Gemfile
COPY Gemfile.lock /question_box/Gemfile.lock
RUN bundle install
COPY . /question_box