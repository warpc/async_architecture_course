require_relative "boot"

require "rails/all"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tasks
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("lib")
    require 'omniauth/strategies/doorkeeper'

    middleware.use OmniAuth::Builder do
      provider :doorkeeper, ENV['TASKS_CLIENT_KEY'], ENV['TASKS_CLIENT_SECRET'], scope: 'public write'
    end
  end
end