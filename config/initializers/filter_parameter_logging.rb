# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password] if Rails.env != "development"
Rails.application.config.filter_parameters += [:password_confirmation] if Rails.env != "development"
