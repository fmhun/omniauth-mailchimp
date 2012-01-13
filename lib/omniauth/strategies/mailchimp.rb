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
=begin
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
=end      

      uid {
        raw_info["user_id"]
      }

      info {
        :first_name => raw_info["contact"]["fname"],
        :last_name => raw_info["contact"]["lname"],
        :email => raw_info["contact"]["email"]
      }
      
      extra {
        :raw_info => raw_info
      }

      def raw_info
        #user_data
        @raw_info ||= MultiJson.parse(@access_token.get("http://us4.api.mailchimp.com/1.3/?method=getAccountDetails"))
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
