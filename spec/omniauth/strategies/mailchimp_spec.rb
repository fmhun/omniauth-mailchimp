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

  #it_should_behave_like 'an OAuth2 strategy'

  describe '#client' do
    it 'has correct MailChimp site' do
      subject.client.site.should eq('https://login.mailchimp.com')
    end
  end
end