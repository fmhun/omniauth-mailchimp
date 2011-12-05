require 'rubygems'
require 'bundler'
require 'sinatra'
require 'omniauth'
require 'omniauth-mailchimp'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class App < Sinatra::Base
  get '/' do
    <<-HTML
    <ul>
      <li><a href='/auth/mailchimp'>Sign in with Mailchimp</a></li>
    </ul>
    HTML
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end
  
  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end
end

use Rack::Session::Cookie, :secret => ENV['RACK_COOKIE_SECRET']

use OmniAuth::Builder do
  provider :mailchimp, "924877707893", "b8c494ebef4e4bb3879daa69e8302896", {}
end

run App.new