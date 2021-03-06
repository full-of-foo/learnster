require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require 'csv'
require "minitest/rails/railtie"

Bundler.require(:default, Rails.env)

module Learnster

  class Application < Rails::Application
    config.force_ssl = (ENV["ENABLE_HTTPS"] == "yes")

    config.action_controller.include_all_helpers = false

    config.assets.enabled = true
    config.assets.paths << "#{Rails.root}/app/assets/fonts"

    config.filter_parameters += [:password, :password_confirmation]

    config.version = '0.9'
  end
end
