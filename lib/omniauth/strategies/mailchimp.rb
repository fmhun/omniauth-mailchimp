require 'omniauth/strategies/oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    class Mailchimp < OmniAuth::Strategies::OAuth2
      
      option :name, "mailchimp"
      
      option :client_options, {
        :site => "https://login.mailchimp.com",
        :authorize_url => '/oauth2/authorize',
        :token_url => '/oauth2/token'
      }
      
      def auth_hash
        data = user_data
        OmniAuth::Utils.deep_merge(
          super, {
            'extra'=> {
              'user_hash' => data
            }
          }
        )
      end

      def user_data
        @data ||= MultiJson.decode(@access_token.get("https://login.mailchimp.com/oauth2/metadata").body)
      rescue ::OAuth2::Error => e
        if e.response.status == 302
          @data ||= MultiJson.decode(@access_token.get(e.response.headers['location']))
        else
          raise e
        end
      end
    end
  end
end