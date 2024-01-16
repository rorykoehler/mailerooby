# frozen_string_literal: true

require_relative "mailerooby/version"
require_relative "mailerooby/email_sender"
require_relative "mailerooby/email_verifier"
require_relative "mailerooby/mailerooby_delivery_method"

module Mailerooby
    class Error < StandardError; end

    class << self
    attr_accessor :sending_api_key, :verifying_api_key
    end

    # Automatically register Maileroob as a delivery method for ActionMailer
    if defined?(ActionMailer)
        ActionMailer::Base.add_delivery_method :mailerooby, MaileroobyDeliveryMethod
    end
end