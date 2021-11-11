module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      option :name, :doorkeeper

      option :client_options,
             authorize_url: "http://localhost:8080/oauth/authorize",
             token_url:     "http://auth:3000/oauth/token"

      uid do
        raw_info["public_id"]
      end

      info do
        {
          email: raw_info["email"],
          full_name: raw_info["full_name"],
          position: raw_info["position"],
          role: raw_info["role"],
          public_id: raw_info["public_id"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get('http://auth:3000/accounts/current.json').parsed
      end
    end
  end
end