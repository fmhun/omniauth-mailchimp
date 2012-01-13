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

      uid {
        raw_info["user_id"]
      }

      info do
        { 
          :first_name => raw_info["contact"]["fname"],
          :last_name => raw_info["contact"]["lname"],
          :email => raw_info["contact"]["email"] 
        }
      end
      
      extra do 
        { 
          :metadata => user_data,
          :raw_info => raw_info
        }
      end

      def raw_info
        @raw_info ||= begin
          data = user_data
          endpoint = data["api_endpoint"]
          apikey = "#{@access_token.token}-#{data['dc']}"
          @access_token.get("#{endpoint}/1.3/?method=getAccountDetails&apikey=#{apikey}").parsed
        end
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
