# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles domain management and verification.
    class Domains
      def initialize(http)
        @http = http
      end

      # Adds a new sending domain.
      #
      # @param domain [String] domain name (e.g., "mail.example.com")
      # @return [Hash] domain with DNS records
      def create(domain:)
        resp = @http.post("/v1/domains", body: { domain: domain })
        resp["data"]
      end

      # Lists domains.
      #
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @return [Hash] paginated list
      def list(limit: nil, cursor: nil)
        @http.get("/v1/domains", query: { limit: limit, cursor: cursor })
      end

      # Gets a single domain.
      #
      # @param id [String] domain ID
      # @return [Hash] domain details
      def get(id)
        resp = @http.get("/v1/domains/#{id}")
        resp["data"]
      end

      # Updates domain settings (tracking configuration).
      #
      # @param id [String] domain ID
      # @param track_opens [Boolean, nil] enable/disable open tracking
      # @param track_clicks [Boolean, nil] enable/disable click tracking
      # @return [Hash] updated domain
      def update(id, track_opens: nil, track_clicks: nil)
        resp = @http.patch("/v1/domains/#{id}", body: {
          trackOpens: track_opens,
          trackClicks: track_clicks
        })
        resp["data"]
      end

      # Triggers DNS verification for a domain.
      #
      # @param id [String] domain ID
      # @return [Hash] domain with updated status
      def verify(id)
        resp = @http.post("/v1/domains/#{id}/verify")
        resp["data"]
      end

      # Deletes a domain.
      #
      # @param id [String] domain ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/domains/#{id}")
        nil
      end
    end
  end
end
