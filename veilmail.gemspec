# frozen_string_literal: true

require_relative "lib/veilmail/version"

Gem::Specification.new do |spec|
  spec.name = "veilmail"
  spec.version = VeilMail::VERSION
  spec.authors = ["Resonia Health"]
  spec.email = ["support@veilmail.xyz"]

  spec.summary = "Official Ruby SDK for Veil Mail — a drop-in alternative to Resend, SendGrid, Mailgun, and Postmark"
  spec.description = "Send secure transactional and marketing email from Ruby and Rails with automatic PII protection. " \
                     "Veil Mail is a drop-in alternative to Resend, SendGrid, Mailgun, and Postmark with full support " \
                     "for emails, domains, templates, audiences, campaigns, automation sequences, webhooks, subscription " \
                     "topics, and contact properties. Includes CASL and GDPR compliance tooling."
  spec.homepage = "https://github.com/Resonia-Health/veilmail-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"] = "https://veilmail.xyz/docs/sdk-ruby"
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://veilmail.xyz/docs/sdk-ruby"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"

  spec.files = Dir["lib/**/*", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "net-http", "~> 0.4"
end
