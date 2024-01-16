# frozen_string_literal: true

require_relative "lib/mailerooby/version"

Gem::Specification.new do |spec|
  spec.name = "mailerooby"
  spec.version = Mailerooby::VERSION
  spec.authors = ["Rory Koehler"]
  spec.email = ["rory@productship.io"]

  spec.summary = "Ruby gem to interact with the Maileroo API."
  spec.homepage = "https://github.com/rorykoehler/mailerooby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rorykoehler/mailerooby"
  spec.metadata["changelog_uri"] = "https://github.com/rorykoehler/mailerooby/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "httparty", "~> 0.21.0"

  spec.add_development_dependency "rake", "~> 13.1.0"
  spec.add_development_dependency "rspec", "~> 3.12.0"
  spec.add_development_dependency "bundler", "~> 2.5"
  spec.add_development_dependency "webmock", "~> 3.19.1"
  spec.add_development_dependency "byebug", "~> 11.1.3"
   

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
