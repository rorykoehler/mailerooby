require 'httparty'

module Mailerooby
    class ValidationError < StandardError; end
    class Error < StandardError; end
    class BadRequestError < Error; end
    class UnauthorizedError < Error; end
    class GeneralAPIError < Error; end

    class EmailVerifier
        include HTTParty
        base_uri 'https://verify.maileroo.net/check'

        def self.verify_email(email_address)
            headers = {
                'X-API-Key' => Mailerooby.verifying_api_key,
                'Content-Type' => 'application/json'
            }
            body = { email_address: email_address }.to_json
            response = post(base_uri, headers: headers, body: body)

            case response.code
            when 400
              raise BadRequestError, "Bad request: #{response.body}"
            when 401
              raise UnauthorizedError, "Unauthorized: #{response.body}"
            when 200
              JSON.parse(response.body)
            else
              raise GeneralAPIError, "API Error: #{response.body}"
            end
        end

        private

        def self.validate_parameters(from:, to:, subject:, body:)
            raise ValidationError, "Email address to verify is missing" if  body[:email_address].nil? || body[:email_address].strip.empty?
            raise ValidationError, "Body is missing" if body.nil? || body.strip.empty?
        end
    end
end