module OmniAuth
  module Strategies
    # tell OmniAuth to load our strategy
    autoload :Doorkeeper, 'omniauth/strategies/doorkeeper'
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :doorkeeper, ENV['BILLING_CLIENT_KEY'], ENV['BILLING_CLIENT_SECRET'], scope: 'public write'
    end
  end
end