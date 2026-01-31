# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles audience and subscriber management.
    class Audiences
      def initialize(http)
        @http = http
      end

      # Creates a new audience.
      #
      # @param name [String] audience name
      # @param description [String, nil] audience description
      # @return [Hash] created audience
      def create(name:, description: nil)
        resp = @http.post("/v1/audiences", body: { name: name, description: description })
        resp["data"]
      end

      # Lists audiences.
      #
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @return [Hash] paginated list
      def list(limit: nil, cursor: nil)
        @http.get("/v1/audiences", query: { limit: limit, cursor: cursor })
      end

      # Gets a single audience.
      #
      # @param id [String] audience ID
      # @return [Hash] audience details
      def get(id)
        resp = @http.get("/v1/audiences/#{id}")
        resp["data"]
      end

      # Updates an audience.
      #
      # @param id [String] audience ID
      # @param name [String, nil] new name
      # @param description [String, nil] new description
      # @return [Hash] updated audience
      def update(id, name: nil, description: nil)
        resp = @http.put("/v1/audiences/#{id}", body: { name: name, description: description })
        resp["data"]
      end

      # Deletes an audience.
      #
      # @param id [String] audience ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/audiences/#{id}")
        nil
      end

      # Returns a Subscribers helper scoped to the given audience.
      #
      # @param audience_id [String] audience ID
      # @return [Subscribers]
      def subscribers(audience_id)
        Subscribers.new(@http, audience_id)
      end

      # Recalculates engagement scores for all subscribers.
      #
      # @param audience_id [String] audience ID
      # @return [Hash] result with processed count
      def recalculate_engagement(audience_id)
        @http.post("/v1/audiences/#{audience_id}/recalculate-engagement", body: {})
      end

      # Gets engagement statistics for an audience.
      #
      # @param audience_id [String] audience ID
      # @return [Hash] engagement stats
      def get_engagement_stats(audience_id)
        @http.get("/v1/audiences/#{audience_id}/engagement-stats")
      end
    end

    # Handles subscriber operations within an audience.
    class Subscribers
      def initialize(http, audience_id)
        @http = http
        @audience_id = audience_id
        @base_path = "/v1/audiences/#{audience_id}/subscribers"
      end

      # Lists subscribers.
      #
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @param status [String, nil] filter by status
      # @param email [String, nil] search by email
      # @return [Hash] paginated list
      def list(limit: nil, cursor: nil, status: nil, email: nil)
        @http.get(@base_path, query: { limit: limit, cursor: cursor, status: status, email: email })
      end

      # Adds a subscriber.
      #
      # @param email [String] subscriber email
      # @param first_name [String, nil] first name
      # @param last_name [String, nil] last name
      # @param metadata [Hash, nil] custom metadata
      # @param double_opt_in [Boolean, nil] use double opt-in
      # @param status [String, nil] "pending" or "active"
      # @param consent_type [String, nil] "express", "implied", or "not_set"
      # @param consent_source [String, nil] how consent was obtained
      # @param consent_date [String, nil] ISO 8601 consent date
      # @param consent_expires_at [String, nil] consent expiration
      # @param consent_proof [String, nil] evidence of consent
      # @return [Hash] created subscriber
      def add(email:, first_name: nil, last_name: nil, metadata: nil,
              double_opt_in: nil, status: nil, consent_type: nil,
              consent_source: nil, consent_date: nil, consent_expires_at: nil,
              consent_proof: nil)
        resp = @http.post(@base_path, body: {
          email: email,
          firstName: first_name,
          lastName: last_name,
          metadata: metadata,
          doubleOptIn: double_opt_in,
          status: status,
          consentType: consent_type,
          consentSource: consent_source,
          consentDate: consent_date,
          consentExpiresAt: consent_expires_at,
          consentProof: consent_proof
        })
        resp["data"]
      end

      # Gets a subscriber.
      #
      # @param subscriber_id [String] subscriber ID
      # @return [Hash] subscriber details
      def get(subscriber_id)
        resp = @http.get("#{@base_path}/#{subscriber_id}")
        resp["data"]
      end

      # Updates a subscriber.
      #
      # @param subscriber_id [String] subscriber ID
      # @param first_name [String, nil] first name
      # @param last_name [String, nil] last name
      # @param metadata [Hash, nil] custom metadata
      # @param status [String, nil] new status
      # @return [Hash] updated subscriber
      def update(subscriber_id, first_name: nil, last_name: nil, metadata: nil, status: nil)
        resp = @http.put("#{@base_path}/#{subscriber_id}", body: {
          firstName: first_name,
          lastName: last_name,
          metadata: metadata,
          status: status
        })
        resp["data"]
      end

      # Removes a subscriber.
      #
      # @param subscriber_id [String] subscriber ID
      # @return [nil]
      def remove(subscriber_id)
        @http.delete("#{@base_path}/#{subscriber_id}")
        nil
      end

      # Confirms a double opt-in subscriber.
      #
      # @param subscriber_id [String] subscriber ID
      # @return [Hash] confirmed subscriber
      def confirm(subscriber_id)
        resp = @http.post("#{@base_path}/#{subscriber_id}/confirm")
        resp["data"]
      end

      # Bulk imports subscribers.
      #
      # @param subscribers [Array<Hash>, nil] array of subscriber entries
      # @param csv_data [String, nil] raw CSV content
      # @return [Hash] import results
      def import(subscribers: nil, csv_data: nil)
        @http.post("#{@base_path}/import", body: {
          subscribers: subscribers,
          csvData: csv_data
        })
      end

      # Exports subscribers as CSV.
      #
      # @param status [String, nil] filter by status
      # @return [String] CSV data
      def export(status: nil)
        @http.get_raw("#{@base_path}/export", query: { status: status })
      end

      # Gets a subscriber's activity timeline.
      #
      # @param subscriber_id [String] subscriber ID
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @param type [String, nil] filter by event type
      # @return [Hash] paginated activity events
      def activity(subscriber_id, limit: nil, cursor: nil, type: nil)
        @http.get("#{@base_path}/#{subscriber_id}/activity",
                  query: { limit: limit, cursor: cursor, type: type })
      end
    end
  end
end
