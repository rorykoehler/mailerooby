require 'spec_helper'
require 'mailerooby/email_sender'

RSpec.describe Mailerooby::EmailSender do
    describe '.send_email' do
        let(:from) { 'sender@example.com' }
        let(:to) { 'recipient@example.com' }
        let(:subject) { 'Test Subject' }
        let(:body) { 'Test Body' }

        before do
            Mailerooby.api_key = 'test_api_key'
        end

        # Helper method to stub HTTP requests
        def stub_maileroo_request(status:, body:)
            stub_request(:post, "https://smtp.maileroo.com/send/").
                with(
                    headers: {
                        'Accept'=>'*/*',
                        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                        'Content-Type'=>'multipart/form-data',
                        'User-Agent'=>'Ruby'
                    }).
                to_return(status: status, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
        end

        it 'sends an email successfully' do
            stub_maileroo_request(status: 200, body: { success: true })
            response = Mailerooby::EmailSender.send_email(from: from, to: to, subject: subject, body: body)
            expect(response['success']).to be true
        end

        it 'handles missing parameters' do
            expect { Mailerooby::EmailSender.send_email(from: from, to: nil, subject: subject, body: body) }
                .to raise_error(Mailerooby::ValidationError)
        end

        context 'when the API returns an error' do
            it 'raises an error' do
                stub_maileroo_request(status: 400, body: { success: false, message: 'Error' })
                expect { Mailerooby::EmailSender.send_email(from: from, to: to, subject: subject, body: body) }
                .to raise_error(Mailerooby::BadRequestError)
            end
        end
    end
end
