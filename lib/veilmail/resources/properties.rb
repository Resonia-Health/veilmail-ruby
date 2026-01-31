# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles contact property management.
    class Properties
      def initialize(http)
        @http = http
      end

      # Creates a new contact property.
      #
      # @param key [String] unique key (alphanumeric + underscore)
      # @param name [String] display name
      # @param type [String, nil] "text", "number", "date", "boolean", or "enum"
      # @param description [String, nil] property description
      # @param required [Boolean, nil] whether the property is required
      # @param enum_options [Array<String>, nil] allowed values for enum type
      # @param sort_order [Integer, nil] display order
      # @return [Hash] created property
      def create(key:, name:, type: nil, description: nil, required: nil,
                 enum_options: nil, sort_order: nil)
        @http.post("/v1/properties", body: {
          key: key,
          name: name,
          type: type,
          description: description,
          required: required,
          enumOptions: enum_options,
          sortOrder: sort_order
        })
      end

      # Lists contact properties.
      #
      # @param active [Boolean, nil] filter by active status
      # @return [Hash] list with :data key
      def list(active: nil)
        @http.get("/v1/properties", query: { active: active&.to_s })
      end

      # Gets a single property.
      #
      # @param id [String] property ID
      # @return [Hash] property details
      def get(id)
        @http.get("/v1/properties/#{id}")
      end

      # Updates a property.
      #
      # @param id [String] property ID
      # @param name [String, nil] new display name
      # @param description [String, nil] new description
      # @param required [Boolean, nil] required status
      # @param enum_options [Array<String>, nil] new enum options
      # @param sort_order [Integer, nil] display order
      # @param active [Boolean, nil] active status
      # @return [Hash] updated property
      def update(id, name: nil, description: nil, required: nil,
                 enum_options: nil, sort_order: nil, active: nil)
        @http.patch("/v1/properties/#{id}", body: {
          name: name,
          description: description,
          required: required,
          enumOptions: enum_options,
          sortOrder: sort_order,
          active: active
        })
      end

      # Deletes (deactivates) a property.
      #
      # @param id [String] property ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/properties/#{id}")
        nil
      end

      # Gets a subscriber's property values.
      #
      # @param audience_id [String] audience ID
      # @param subscriber_id [String] subscriber ID
      # @return [Hash] property values
      def get_values(audience_id, subscriber_id)
        @http.get("/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/properties")
      end

      # Sets property values for a subscriber.
      #
      # @param audience_id [String] audience ID
      # @param subscriber_id [String] subscriber ID
      # @param values [Hash] property key => value pairs (nil to delete)
      # @return [Hash] result
      def set_values(audience_id, subscriber_id, values)
        @http.put("/v1/audiences/#{audience_id}/subscribers/#{subscriber_id}/properties",
                  body: { values: values })
      end
    end
  end
end
