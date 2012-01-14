require 'rubygems'
require 'bundler'
require 'sinatra'
require 'omniauth'
require 'omniauth-mailchimp'

get '/' do
  <<-HTML
	<div>
		Your credentials are :
		<ul>
			<li>client id : #{ENV["MC_KEY"]}</li>
			<li>secret key : #{ENV["MC_SECRET"]}</li>
		</ul>
	</div>
  <a href='/auth/mailchimp'>Sign in with MailChimp</a>
  HTML
end

get '/auth/:provider/callback' do
  content_type 'text/plain'
	token = request.env['omniauth.auth']['credentials']['token']
  dc = request.env['omniauth.auth']['extra']['user_hash']['dc']
  "Standard API key is #{token}-#{dc}".inspect rescue "No data"
end

get '/auth/failure' do
  content_type 'text/plain'
  request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
end

use Rack::Session::Cookie, :secret => ENV['RACK_COOKIE_SECRET']

use OmniAuth::Builder do
  provider :mailchimp, ENV["MC_KEY"], ENV["MC_SECRET"]
end