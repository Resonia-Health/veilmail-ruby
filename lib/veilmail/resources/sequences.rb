# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles automation sequence management.
    class Sequences
      def initialize(http)
        @http = http
      end

      # Creates a new automation sequence.
      #
      # @param name [String] sequence name
      # @param audience_id [String] target audience ID
      # @param trigger_type [String] trigger type ('audience_join', 'segment_match', 'manual')
      # @param description [String, nil] sequence description
      # @param trigger_config [Hash, nil] trigger configuration
      # @return [Hash] created sequence
      def create(name:, audience_id:, trigger_type:, description: nil, trigger_config: nil)
        resp = @http.post("/v1/sequences", body: {
          name: name,
          audienceId: audience_id,
          triggerType: trigger_type,
          description: description,
          triggerConfig: trigger_config
        })
        resp
      end

      # Lists sequences.
      #
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @return [Hash] paginated list
      def list(limit: nil, cursor: nil)
        @http.get("/v1/sequences", query: { limit: limit, cursor: cursor })
      end

      # Gets a single sequence.
      #
      # @param id [String] sequence ID
      # @return [Hash] sequence details
      def get(id)
        @http.get("/v1/sequences/#{id}")
      end

      # Updates a sequence (only DRAFT or PAUSED).
      #
      # @param id [String] sequence ID
      # @return [Hash] updated sequence
      def update(id, **params)
        body = {
          name: params[:name],
          description: params[:description],
          triggerType: params[:trigger_type],
          triggerConfig: params[:trigger_config]
        }
        @http.put("/v1/sequences/#{id}", body: body)
      end

      # Deletes a sequence (only DRAFT).
      #
      # @param id [String] sequence ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/sequences/#{id}")
        nil
      end

      # Activates a sequence.
      #
      # @param id [String] sequence ID
      # @return [Hash] activated sequence
      def activate(id)
        @http.post("/v1/sequences/#{id}/activate")
      end

      # Pauses an active sequence.
      #
      # @param id [String] sequence ID
      # @return [Hash] paused sequence
      def pause(id)
        @http.post("/v1/sequences/#{id}/pause")
      end

      # Archives a sequence.
      #
      # @param id [String] sequence ID
      # @return [Hash] archived sequence
      def archive(id)
        @http.post("/v1/sequences/#{id}/archive")
      end

      # Adds a step to a sequence.
      #
      # @param sequence_id [String] sequence ID
      # @param position [Integer] step position
      # @param type [String] step type ('email', 'delay', 'condition')
      # @return [Hash] created step
      def add_step(sequence_id, position:, type:, subject: nil, html: nil,
                   text: nil, template_id: nil, delay_amount: nil,
                   delay_unit: nil, condition_type: nil, condition_config: nil)
        @http.post("/v1/sequences/#{sequence_id}/steps", body: {
          position: position,
          type: type,
          subject: subject,
          html: html,
          text: text,
          templateId: template_id,
          delayAmount: delay_amount,
          delayUnit: delay_unit,
          conditionType: condition_type,
          conditionConfig: condition_config
        })
      end

      # Updates a sequence step.
      #
      # @param sequence_id [String] sequence ID
      # @param step_id [String] step ID
      # @return [Hash] updated step
      def update_step(sequence_id, step_id, **params)
        body = {
          subject: params[:subject],
          html: params[:html],
          text: params[:text],
          templateId: params[:template_id],
          delayAmount: params[:delay_amount],
          delayUnit: params[:delay_unit],
          conditionType: params[:condition_type],
          conditionConfig: params[:condition_config]
        }
        @http.put("/v1/sequences/#{sequence_id}/steps/#{step_id}", body: body)
      end

      # Deletes a sequence step.
      #
      # @param sequence_id [String] sequence ID
      # @param step_id [String] step ID
      # @return [nil]
      def delete_step(sequence_id, step_id)
        @http.delete("/v1/sequences/#{sequence_id}/steps/#{step_id}")
        nil
      end

      # Reorders sequence steps.
      #
      # @param sequence_id [String] sequence ID
      # @param steps [Array<Hash>] array of {id:, position:}
      # @return [nil]
      def reorder_steps(sequence_id, steps)
        @http.post("/v1/sequences/#{sequence_id}/steps/reorder", body: { steps: steps })
        nil
      end

      # Enrolls subscribers into a sequence.
      #
      # @param sequence_id [String] sequence ID
      # @param subscriber_ids [Array<String>] subscriber IDs
      # @return [Hash] result with enrolled count
      def enroll(sequence_id, subscriber_ids)
        @http.post("/v1/sequences/#{sequence_id}/enroll",
                   body: { subscriberIds: subscriber_ids })
      end

      # Lists enrollments for a sequence.
      #
      # @param sequence_id [String] sequence ID
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @return [Hash] paginated list
      def list_enrollments(sequence_id, limit: nil, cursor: nil)
        @http.get("/v1/sequences/#{sequence_id}/enrollments",
                  query: { limit: limit, cursor: cursor })
      end

      # Removes an enrollment from a sequence.
      #
      # @param sequence_id [String] sequence ID
      # @param enrollment_id [String] enrollment ID
      # @return [nil]
      def remove_enrollment(sequence_id, enrollment_id)
        @http.delete("/v1/sequences/#{sequence_id}/enrollments/#{enrollment_id}")
        nil
      end
    end
  end
end
