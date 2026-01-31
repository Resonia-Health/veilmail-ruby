# frozen_string_literal: true

require_relative "lib/veilmail/version"

Gem::Specification.new do |spec|
  spec.name = "veilmail"
  spec.version = VeilMail::VERSION
  spec.authors = ["Resonia Health"]
  spec.email = ["support@veilmail.xyz"]

  spec.summary = "Official Ruby SDK for the Veil Mail API"
  spec.description = "Send emails with built-in PII protection using the Veil Mail API. " \
                     "Full support for emails, domains, templates, audiences, campaigns, " \
                     "webhooks, topics, and contact properties."
  spec.homepage = "https://github.com/Resonia-Health/veilmail-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://veilmail.xyz/docs/sdk-ruby"

  spec.files = Dir["lib/**/*", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "net-http", "~> 0.4"
end
