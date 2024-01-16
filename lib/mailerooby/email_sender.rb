require 'httparty'

module Mailerooby
    class ValidationError < StandardError; end
    class Error < StandardError; end
    class BadRequestError < Error; end
    class UnauthorizedError < Error; end
    class GeneralAPIError < Error; end
    class EmailSender
        include HTTParty
        base_uri 'https://smtp.maileroo.com/send'

        def self.send_email(from:, to:, subject:, body:, cc: nil, bcc: nil, reply_to: nil, attachments: nil)
            validate_parameters(from: from, to: to, subject: subject, body: body)
            headers = {
                'X-API-Key' => Mailerooby.sending_api_key
            }
            body = { from: from, to: to, subject: subject, body: body, cc: cc, bcc: bcc, reply_to: reply_to, attachments: attachments }
            response = post(base_uri, headers: headers, body: body, multipart: true)
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
            raise ValidationError, "From address is missing" if from.nil? || from.strip.empty?
            raise ValidationError, "To address is missing" if to.nil? || to.strip.empty?
            raise ValidationError, "Subject is missing" if subject.nil? || subject.strip.empty?
            raise ValidationError, "Body is missing" if body.nil? || body.strip.empty?
        end

    end
end