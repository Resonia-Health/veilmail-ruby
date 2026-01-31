# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles email template management.
    class Templates
      def initialize(http)
        @http = http
      end

      # Creates a new template.
      #
      # @param name [String] template name
      # @param subject [String] subject line (supports {{variables}})
      # @param html [String] HTML body (supports {{variables}})
      # @param text [String, nil] plain text body
      # @param type [String, nil] "transactional" or "marketing"
      # @param variables [Array<Hash>, nil] variable definitions
      # @param description [String, nil] template description
      # @return [Hash] created template
      def create(name:, subject:, html:, text: nil, type: nil, variables: nil, description: nil)
        resp = @http.post("/v1/templates", body: {
          name: name,
          subject: subject,
          html: html,
          text: text,
          type: type,
          variables: variables,
          description: description
        })
        resp["data"]
      end

      # Lists templates.
      #
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @return [Hash] paginated list
      def list(limit: nil, cursor: nil)
        @http.get("/v1/templates", query: { limit: limit, cursor: cursor })
      end

      # Gets a single template.
      #
      # @param id [String] template ID
      # @return [Hash] template details
      def get(id)
        resp = @http.get("/v1/templates/#{id}")
        resp["data"]
      end

      # Updates a template.
      #
      # @param id [String] template ID
      # @return [Hash] updated template
      def update(id, name: nil, subject: nil, html: nil, text: nil, type: nil, variables: nil, description: nil)
        resp = @http.patch("/v1/templates/#{id}", body: {
          name: name,
          subject: subject,
          html: html,
          text: text,
          type: type,
          variables: variables,
          description: description
        })
        resp["data"]
      end

      # Previews a template with variables.
      #
      # @param html [String] HTML content
      # @param subject [String, nil] subject line
      # @param variables [Hash, nil] variable values
      # @return [Hash] rendered preview
      def preview(html:, subject: nil, variables: nil)
        @http.post("/v1/templates/preview", body: {
          html: html,
          subject: subject,
          variables: variables
        })
      end

      # Deletes a template.
      #
      # @param id [String] template ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/templates/#{id}")
        nil
      end
    end
  end
end
