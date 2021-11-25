module OmniAuth
  module Strategies
    # tell OmniAuth to load our strategy
    autoload :Doorkeeper, 'omniauth/strategies/doorkeeper'
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :doorkeeper, ENV['ANALYTICS_CLIENT_KEY'], ENV['ANALYTICS_CLIENT_SECRET'], scope: 'public write'
    end
  end
end