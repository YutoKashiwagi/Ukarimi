source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'bootstrap', '~> 4.4.1'
gem 'jquery-rails', '4.3.1'
gem 'sass-rails', '5.0.6'
gem 'carrierwave'
gem 'mini_magick'
gem 'coffee-rails', '4.2.2'
gem 'devise'
gem 'devise-bootstrap-views', '~> 1.0'
gem 'devise-i18n'       # devise日本語化のため
gem 'devise-i18n-views' # devise日本語化のため
gem 'dotenv-rails'
gem 'faker'
gem 'jbuilder', '2.7.0'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'puma', '3.9.1'
gem 'rails', '5.2.0'
gem 'bootsnap'
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
# enum日本語化用
gem 'enum_help'
# Ukarimiからukarimiに改名するためのgem
gem 'rename'
# s3への画像アップロード
gem 'fog-aws'

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
  gem 'guard-rspec', require: false
  gem 'bullet'
  # debug
  gem "better_errors"
  gem "binding_of_caller"
  gem 'pry-doc'
  gem 'pry-rails'
end

group :test do
  gem 'capybara', '3.25.0'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :production, :staging do
  gem 'unicorn'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
