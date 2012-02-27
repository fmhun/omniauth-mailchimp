require 'spec_helper'
require 'omniauth-mailchimp'

describe OmniAuth::Strategies::Mailchimp do
  before :each do
    @request = double('Request')
    @request.stub(:params) { {} }
  end
  
  subject do
    OmniAuth::Strategies::Mailchimp.new(nil, @options || {}).tap do |strategy|
      strategy.stub(:request) { @request }
    end
  end

  it_should_behave_like 'an oauth2 strategy'

	describe '#client' do
    it 'has correct Mailchimp api site' do
      subject.options.client_options.site.should eq('https://login.mailchimp.com')
    end

    it 'has correct access token path' do
      subject.options.client_options.token_url.should eq('/oauth2/token')
    end

    it 'has correct authorize url' do
      subject.options.client_options.authorize_url.should eq('/oauth2/authorize')
    end
  end

	describe '#callback_path' do
    it 'should have the correct callback path' do
      subject.callback_path.should eq('/auth/mailchimp/callback')
    end
  end
end