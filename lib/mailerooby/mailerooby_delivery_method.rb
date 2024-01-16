require 'mailerooby'

class MaileroobyDeliveryMethod
    def initialize(values)
      self.settings = values
    end

    attr_accessor :settings

    def deliver!(mail)
        from = mail.from.join(', ')
        to = mail.to.join(', ')
        subject = mail.subject
        body = mail.body.raw_source
        cc = mail.cc.join(', ') if mail.cc.present?
        bcc = mail.bcc.join(', ') if mail.bcc.present?
        reply_to = mail.reply_to if mail.reply_to.present?
        attachments = extract_attachments(mail)
        # Send the email via Maileroob API
        response = Mailerooby::EmailSender.send_email(from: from, 
                                                      to: to, 
                                                      subject: subject, 
                                                      body: body, 
                                                      cc: cc, 
                                                      bcc: bcc, 
                                                      reply_to: reply_to, 
                                                      attachments: attachments)
    
        # Check the response and raise an error if necessary
        handle_response(response)
    end
    
    private

    def extract_attachments(mail)
        mail.attachments.map do |attachment|
          {
            name: attachment.filename,
            content: attachment.body.raw_source,
            type: attachment.mime_type
          }
        end
    end
    
    def handle_response(response)
        unless response["success"]
            error_message = response["message"] || "Unknown error"
            raise Mailerooby::DeliveryError.new("Failed to send email: #{error_message}")
        end
    end
end

module Mailerooby
    class DeliveryError < StandardError; end
end
  
