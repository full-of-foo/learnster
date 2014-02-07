require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require 'csv'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Learnster
  class Application < Rails::Application
    config.force_ssl = (ENV["ENABLE_HTTPS"] == "yes")
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_controller.include_all_helpers = false

    config.assets.enabled = true
    config.assets.paths << "#{Rails.root}/app/assets/fonts"

    config.filter_parameters += [:password, :password_confirmation]

  end
end
