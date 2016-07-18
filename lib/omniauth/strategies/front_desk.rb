require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class FrontDesk < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://frontdeskhq.com/',
        :authorize_url => 'https://frontdeskhq.com/oauth/authorize?',
        :token_url => 'https://frontdeskhq.com/oauth/token'
      }

      uid { raw_info["id"] }

      extra do
        raw_info
      end

      def request_phase
        super
      end

      def raw_info
        @raw_info ||= MultiJson.load(access_token.get('https://frontdeskhq.com/api/v2/front/account.json').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

    end
  end
end

OmniAuth.config.add_camelization 'frontdesk', 'FrontDesk'
