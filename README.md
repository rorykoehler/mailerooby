# Mailerooby

## Installation

Install the gem and add to the application"s Gemfile by executing:

    $ bundle add mailerooby

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install mailerooby

## Usage

After installing your gem, it can be used in a Rails application as follows:

1. **Rails Initializer (config/initializers/mailerooby.rb)**

    ```
    Mailerooby.sending_api_key = "your_sending_api_key_here"
    Mailerooby.verifying_api_key = "your_verifying_api_key_here"
    ```
Of course the api keys should be stored in the Rails encrypted credentials as is best practice.

2. **Sending an Email - In Rails With ActionMailer**

    Use as normal as per the Rails ActionMailer docs. E.G.

    ```
    UserMailer.password_reset_success_notification(@user).deliver_now
    ```

    **See Rails configuration and more detailed example below**

3. **Sending an Email - Plain Ruby Without Rails**

    ```
    Mailerooby::EmailSender.send_email(
        from: "sender@example.com",
        to: "recipient@example.com",
        subject: "Test Email",
        body: "This is a test email."
    )
    ```
    
4. **Verifying an Email Address**

    ```ruby
        response = Mailerooby::EmailVerifier.verify_email("test@example")
        if response["success"]
            puts "Email is valid."
            # Additional logic for valid email
        else
            puts "Email verification failed: #{response["message"]}"
            # Additional logic for failed verification
        end
    ```

## Rais - Configure ActionMailer to Use the Custom Delivery Method

In your Rails environment configuration file (e.g., config/environments/production.rb), configure ActionMailer to use your new delivery method:

```
    Rails.application.configure do
        # Other configuration...
        config.action_mailer.delivery_method = :mailerooby
    end
```

### Send Emails Using ActionMailer

Now, you can use ActionMailer as usual in your Rails application, and emails will be sent through the Maileroo API.

For example, in a mailer class:

```
    class UserMailer < ApplicationMailer
        def welcome_email(user, attachment_paths)
            @user = user
            attachment_paths.each do |path|
                file_name = File.basename(path)
                attachments[file_name] = File.read(path, mode: 'rb')
            end
            mail(to: @user.email, subject: "We're using Mailerooby")
        end
    end
```

When UserMailer.welcome_email(user).deliver_now is called, it will use the MaileroobyDeliveryMethod to send the email via the Maileroo API.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rorykoehler/mailerooby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rorykoehler/mailerooby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Be patient and kind.

Everyone interacting in the Mailerooby project"s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/mailerooby/blob/main/CODE_OF_CONDUCT.md).
