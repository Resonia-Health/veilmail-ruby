# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles signup form management.
    class Forms
      def initialize(http)
        @http = http
      end

      # Creates a new signup form.
      #
      # @param name [String] form name
      # @param audience_id [String] target audience ID
      # @param fields [Array<Hash>, nil] form field configuration
      # @param double_opt_in [Boolean, nil] enable double opt-in
      # @param redirect_url [String, nil] redirect URL after submission
      # @param honeypot [Boolean, nil] enable honeypot spam protection
      # @param casl_consent [Boolean, nil] require CASL consent
      # @return [Hash] created form
      def create(name:, audience_id:, fields: nil, double_opt_in: nil,
                 redirect_url: nil, honeypot: nil, casl_consent: nil)
        @http.post("/v1/forms", body: {
          name: name,
          audienceId: audience_id,
          fields: fields,
          doubleOptIn: double_opt_in,
          redirectUrl: redirect_url,
          honeypot: honeypot,
          caslConsent: casl_consent
        })
      end

      # Lists all signup forms.
      #
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @return [Hash] paginated list
      def list(limit: nil, cursor: nil)
        @http.get("/v1/forms", query: { limit: limit, cursor: cursor })
      end

      # Gets a single form by ID.
      #
      # @param id [String] form ID
      # @return [Hash] form details
      def get(id)
        @http.get("/v1/forms/#{id}")
      end

      # Updates a form.
      #
      # @param id [String] form ID
      # @return [Hash] updated form
      def update(id, **params)
        body = {
          name: params[:name],
          fields: params[:fields],
          doubleOptIn: params[:double_opt_in],
          redirectUrl: params[:redirect_url],
          honeypot: params[:honeypot],
          caslConsent: params[:casl_consent]
        }
        @http.put("/v1/forms/#{id}", body: body)
      end

      # Deletes a form.
      #
      # @param id [String] form ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/forms/#{id}")
        nil
      end
    end
  end
end
