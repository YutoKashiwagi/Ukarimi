require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ukarimi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    # sqlite3用の設定
    config.active_record.sqlite3.represent_boolean_as_integer = true

    config.load_defaults 5.1

    config.time_zone = 'Tokyo'
    
    config.i18n.default_locale = :ja # 日本語化

    #自動生成の設定
    config.generators do |g|
      g.helper false
      g.assets false
      g.skip_routes true
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
