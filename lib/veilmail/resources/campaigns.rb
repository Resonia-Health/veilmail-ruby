# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles campaign management.
    class Campaigns
      def initialize(http)
        @http = http
      end

      # Creates a new campaign.
      #
      # @param name [String] campaign name
      # @param subject [String] email subject
      # @param from [String] sender address
      # @param audience_id [String] target audience ID
      # @param reply_to [String, nil] reply-to address
      # @param template_id [String, nil] template ID
      # @param html [String, nil] HTML content
      # @param text [String, nil] plain text content
      # @param variables [Hash, nil] template variables
      # @param preview_text [String, nil] email preview text
      # @param tags [Array<String>, nil] tags
      # @return [Hash] created campaign
      def create(name:, subject:, from:, audience_id:, reply_to: nil,
                 template_id: nil, html: nil, text: nil, variables: nil,
                 preview_text: nil, tags: nil)
        resp = @http.post("/v1/campaigns", body: {
          name: name,
          subject: subject,
          from: from,
          replyTo: reply_to,
          audienceId: audience_id,
          templateId: template_id,
          html: html,
          text: text,
          variables: variables,
          previewText: preview_text,
          tags: tags
        })
        resp["data"]
      end

      # Lists campaigns.
      #
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @return [Hash] paginated list
      def list(limit: nil, cursor: nil)
        @http.get("/v1/campaigns", query: { limit: limit, cursor: cursor })
      end

      # Gets a single campaign.
      #
      # @param id [String] campaign ID
      # @return [Hash] campaign details
      def get(id)
        resp = @http.get("/v1/campaigns/#{id}")
        resp["data"]
      end

      # Updates a draft campaign.
      #
      # @param id [String] campaign ID
      # @return [Hash] updated campaign
      def update(id, **params)
        body = {
          name: params[:name],
          subject: params[:subject],
          from: params[:from],
          replyTo: params[:reply_to],
          audienceId: params[:audience_id],
          templateId: params[:template_id],
          html: params[:html],
          text: params[:text],
          variables: params[:variables],
          previewText: params[:preview_text],
          tags: params[:tags]
        }
        resp = @http.patch("/v1/campaigns/#{id}", body: body)
        resp["data"]
      end

      # Deletes a campaign.
      #
      # @param id [String] campaign ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/campaigns/#{id}")
        nil
      end

      # Schedules a campaign for future delivery.
      #
      # @param id [String] campaign ID
      # @param scheduled_at [String] ISO 8601 time
      # @return [Hash] updated campaign
      def schedule(id, scheduled_at:)
        resp = @http.post("/v1/campaigns/#{id}/schedule", body: { scheduledAt: scheduled_at })
        resp["data"]
      end

      # Sends a campaign immediately.
      #
      # @param id [String] campaign ID
      # @return [Hash] updated campaign
      def send_now(id)
        resp = @http.post("/v1/campaigns/#{id}/send")
        resp["data"]
      end

      # Pauses an in-progress campaign.
      #
      # @param id [String] campaign ID
      # @return [Hash] updated campaign
      def pause(id)
        resp = @http.post("/v1/campaigns/#{id}/pause")
        resp["data"]
      end

      # Resumes a paused campaign.
      #
      # @param id [String] campaign ID
      # @return [Hash] updated campaign
      def resume(id)
        resp = @http.post("/v1/campaigns/#{id}/resume")
        resp["data"]
      end

      # Cancels a scheduled or in-progress campaign.
      #
      # @param id [String] campaign ID
      # @return [Hash] updated campaign
      def cancel(id)
        resp = @http.post("/v1/campaigns/#{id}/cancel")
        resp["data"]
      end

      # Sends a test/preview of a campaign.
      #
      # @param id [String] campaign ID
      # @param to [Array<String>] test email addresses (max 5)
      # @return [Hash] test send result
      def send_test(id, to:)
        @http.post("/v1/campaigns/#{id}/test", body: { to: to })
      end

      # Clones a campaign as a new draft.
      #
      # @param id [String] campaign ID
      # @param include_ab_test [Boolean, nil] include A/B test variants
      # @return [Hash] cloned campaign
      def clone(id, include_ab_test: nil)
        body = {}
        body[:includeABTest] = include_ab_test unless include_ab_test.nil?
        @http.post("/v1/campaigns/#{id}/clone", body: body)
      end

      # Gets tracked link analytics for a campaign.
      #
      # @param id [String] campaign ID
      # @param limit [Integer, nil] max links to return
      # @param sort [String, nil] sort field
      # @param order [String, nil] sort order ('asc' or 'desc')
      # @return [Hash] link analytics data
      def links(id, limit: nil, sort: nil, order: nil)
        @http.get("/v1/campaigns/#{id}/links",
                  query: { limit: limit, sort: sort, order: order })
      end
    end
  end
end
