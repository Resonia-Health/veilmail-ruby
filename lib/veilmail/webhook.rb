# frozen_string_literal: true

require "openssl"

module VeilMail
  module Webhook
    # Verifies a webhook signature using constant-time HMAC-SHA256 comparison.
    #
    # @param body [String] the raw request body
    # @param signature [String] the signature from the X-Signature-Hash header
    # @param secret [String] the webhook signing secret
    # @return [Boolean] true if the signature is valid
    #
    # @example Verify a webhook in a Rails controller
    #   def webhook
    #     body = request.raw_post
    #     signature = request.headers["X-Signature-Hash"]
    #
    #     unless VeilMail::Webhook.verify_signature(body, signature, ENV["WEBHOOK_SECRET"])
    #       head :unauthorized
    #       return
    #     end
    #
    #     event = JSON.parse(body)
    #     # Process event...
    #     head :ok
    #   end
    def self.verify_signature(body, signature, secret)
      expected = OpenSSL::HMAC.hexdigest("SHA256", secret, body)
      secure_compare(expected, signature)
    end

    # Constant-time string comparison to prevent timing attacks.
    def self.secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      OpenSSL.fixed_length_secure_compare(a, b)
    rescue StandardError
      false
    end
  end
end
