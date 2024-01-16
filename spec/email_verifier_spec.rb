require 'spec_helper'
require 'mailerooby/email_verifier'

RSpec.describe Mailerooby::EmailVerifier do
  describe '.verify_email' do
    let(:email_address) { 'test@example.com' }

    before do
      Mailerooby.api_key = 'test_api_key'
    end

    def stub_maileroo_request(status:, body:)
        stub_request(:post, "https://verify.maileroo.net/check/").
            with(
                headers: {
                    'Accept'=>'*/*',
                    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                    'Content-Type'=>'application/json',
                    'User-Agent'=>'Ruby'
                }).
            to_return(status: status, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'successfully verifies an email address' do
        stub_maileroo_request(status: 200, body: { verified: true })
        response = Mailerooby::EmailVerifier.verify_email(email_address)
        expect(response['verified']).to be true
    end
      
    context 'when email is invalid' do
        before do
            stub_maileroo_request(status: 200, body: { verified: false })
        end
        
        it 'returns false for invalid email' do
            response = Mailerooby::EmailVerifier.verify_email('invalid@example.com')
            expect(response['verified']).to be false
        end
    end
      
    context 'when the API returns an error' do
        before do
            stub_maileroo_request(status: 401, body: { error: 'Invalid API key' })
            .to_return(status: 401, body: { error: 'Invalid API key' }.to_json)
        end
      
        it 'raises an error for invalid API key' do
          expect { Mailerooby::EmailVerifier.verify_email(email_address) }
            .to raise_error(Mailerooby::Error)
        end
      end
      
  end
end
