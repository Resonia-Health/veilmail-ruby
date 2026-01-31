# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles webhook management.
    class Webhooks
      def initialize(http)
        @http = http
      end

      # Creates a new webhook.
      #
      # @param url [String] webhook endpoint URL
      # @param events [Array<String>] event types to subscribe to
      # @param description [String, nil] webhook description
      # @param enabled [Boolean, nil] whether the webhook is enabled
      # @return [Hash] created webhook with signing secret
      def create(url:, events:, description: nil, enabled: nil)
        resp = @http.post("/v1/webhooks", body: {
          url: url,
          events: events,
          description: description,
          enabled: enabled
        })
        resp["data"]
      end

      # Lists webhooks.
      #
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @return [Hash] paginated list
      def list(limit: nil, cursor: nil)
        @http.get("/v1/webhooks", query: { limit: limit, cursor: cursor })
      end

      # Gets a single webhook.
      #
      # @param id [String] webhook ID
      # @return [Hash] webhook details
      def get(id)
        resp = @http.get("/v1/webhooks/#{id}")
        resp["data"]
      end

      # Updates a webhook.
      #
      # @param id [String] webhook ID
      # @param url [String, nil] new URL
      # @param events [Array<String>, nil] new event types
      # @param description [String, nil] new description
      # @param enabled [Boolean, nil] enabled status
      # @return [Hash] updated webhook
      def update(id, url: nil, events: nil, description: nil, enabled: nil)
        resp = @http.patch("/v1/webhooks/#{id}", body: {
          url: url,
          events: events,
          description: description,
          enabled: enabled
        })
        resp["data"]
      end

      # Deletes a webhook.
      #
      # @param id [String] webhook ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/webhooks/#{id}")
        nil
      end

      # Sends a test event to the webhook endpoint.
      #
      # @param id [String] webhook ID
      # @return [Hash] test result with success, statusCode, responseTime
      def test(id)
        resp = @http.post("/v1/webhooks/#{id}/test")
        resp["data"]
      end

      # Rotates the webhook's signing secret.
      #
      # @param id [String] webhook ID
      # @return [Hash] webhook with new secret
      def rotate_secret(id)
        resp = @http.post("/v1/webhooks/#{id}/rotate-secret")
        resp["data"]
      end
    end
  end
end
