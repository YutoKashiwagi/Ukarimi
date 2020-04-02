FROM ruby:2.6.3
RUN apt-get update -qq && \
    apt-get install -y build-essential \
    nodejs \
    imagemagick

# system_specで使うchromeのインストール
RUN sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

RUN mkdir /question_box
WORKDIR /question_box
COPY Gemfile /question_box/Gemfile
COPY Gemfile.lock /question_box/Gemfile.lock
RUN bundle install
COPY . /question_box
