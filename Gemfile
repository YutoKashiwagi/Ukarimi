source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# gem 'ast', '2.4.0'
gem 'bootstrap', '~> 4.4.1'
gem 'jquery-rails', '4.3.1'
gem 'sass-rails', '5.0.6'
gem 'carrierwave'
gem 'coffee-rails', '4.2.2'
gem 'devise'
gem 'devise-bootstrap-views', '~> 1.0'
gem 'devise-i18n'       # devise日本語化のため
gem 'devise-i18n-views' # devise日本語化のため
gem 'dotenv-rails'
gem 'faker'
gem 'jbuilder', '2.7.0'
gem 'mini_magick'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'puma', '3.12.3'
gem 'rails', '5.1.7'
gem 'turbolinks',   '5.0.1'
gem 'uglifier',     '3.2.0'
gem 'mysql2'
# 検索用
gem 'ransack'
# フォント用
gem 'font-awesome-sass'
# slimのジェネレーターを提供してくれるslim-rails
gem 'slim-rails'
# erb→slim記法に変換するためのgem
gem 'html2slim'
# ページネーション(will_pagenateより操作性とカスタマイズ性で優れている)
gem 'kaminari'
# SQL、パフォーマンスのチェック
gem 'rack-mini-profiler', require: false
# data: { confirm: }のダイアログをbootstrapを使ってカスタマイズするジェム
gem 'data-confirm-modal'

group :development, :test do
  gem 'byebug', '9.0.6', platform: :mri
  gem 'spring-commands-rspec'
  gem 'sqlite3', '1.3.13'
  gem "rspec_junit_formatter"
end

group :development do
  gem 'rubocop-airbnb'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console',           '3.5.1'
  # debug
  gem "better_errors"
  gem "binding_of_caller"
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
end

group :test do
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
  gem 'minitest-reporters',       '1.1.14'
  gem 'launchy'
  gem 'rails-controller-testing', '1.0.2'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
