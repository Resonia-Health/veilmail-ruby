# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles subscription topic management.
    class Topics
      def initialize(http)
        @http = http
      end

      # Creates a new topic.
      #
      # @param name [String] topic name
      # @param description [String, nil] topic description
      # @param is_default [Boolean, nil] auto-subscribe new subscribers
      # @param sort_order [Integer, nil] display order
      # @return [Hash] created topic
      def create(name:, description: nil, is_default: nil, sort_order: nil)
        @http.post("/v1/topics", body: {
          name: name,
          description: description,
          isDefault: is_default,
          sortOrder: sort_order
        })
      end

      # Lists topics.
      #
      # @param active [Boolean, nil] filter by active status
      # @return [Hash] list with :data key
      def list(active: nil)
        @http.get("/v1/topics", query: { active: active&.to_s })
      end

      # Gets a single topic.
      #
      # @param id [String] topic ID
      # @return [Hash] topic details
      def get(id)
        @http.get("/v1/topics/#{id}")
      end

      # Updates a topic.
      #
      # @param id [String] topic ID
      # @param name [String, nil] new name
      # @param description [String, nil] new description
      # @param is_default [Boolean, nil] default status
      # @param sort_order [Integer, nil] display order
      # @param active [Boolean, nil] active status
      # @return [Hash] updated topic
      def update(id, name: nil, description: nil, is_default: nil, sort_order: nil, active: nil)
        @http.patch("/v1/topics/#{id}", body: {
          name: name,
          description: description,
          isDefault: is_default,
          sortOrder: sort_order,
          active: active
        })
      end

      # Deletes (deactivates) a topic.
      #
      # @param id [String] topic ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/topics/#{id}")
        nil
      end

      # Gets a subscriber's topic preferences.
      #
      # @param audience_id [String] audience ID
      # @param subscriber_id [String] subscriber ID
      # @return [Hash] list of topic preferences
      def get_preferences(audience_id, subscriber_id)
        @http.get("/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/topics")
      end

      # Sets a subscriber's topic preferences.
      #
      # @param audience_id [String] audience ID
      # @param subscriber_id [String] subscriber ID
      # @param topics [Array<Hash>] array of { topic_id:, subscribed: }
      # @return [Hash] updated preferences
      def set_preferences(audience_id, subscriber_id, topics:)
        formatted = topics.map { |t| { topicId: t[:topic_id], subscribed: t[:subscribed] } }
        @http.put("/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/topics",
                  body: { topics: formatted })
      end
    end
  end
end
