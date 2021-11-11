module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      option :name, :doorkeeper

      option :client_options,
             site: ENV["DOORKEEPER_APP_URL"],
             authorize_path: "/oauth/authorize"

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
        @raw_info ||= access_token.get("/accounts/current.json").parsed
      end
    end
  end
end