# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles email sending and management.
    class Emails
      def initialize(http)
        @http = http
      end

      # Sends a single email.
      #
      # @param from [String] sender address ("Name <email>" or "email")
      # @param to [String, Array<String>] recipient(s)
      # @param subject [String] email subject
      # @param html [String, nil] HTML body
      # @param text [String, nil] plain text body
      # @param cc [String, Array<String>, nil] CC recipients
      # @param bcc [String, Array<String>, nil] BCC recipients
      # @param reply_to [String, nil] reply-to address
      # @param template_id [String, nil] template ID
      # @param template_data [Hash, nil] template variables
      # @param scheduled_for [String, nil] ISO 8601 scheduled time
      # @param tags [Array<String>, nil] categorization tags
      # @param metadata [Hash, nil] custom metadata
      # @param idempotency_key [String, nil] deduplication key
      # @param attachments [Array<Hash>, nil] file attachments
      # @param topic_id [String, nil] subscription topic ID
      # @param type [String, nil] "transactional" or "marketing"
      # @return [Hash] the created email
      def send(from:, to:, subject:, html: nil, text: nil, cc: nil, bcc: nil,
               reply_to: nil, template_id: nil, template_data: nil,
               scheduled_for: nil, tags: nil, metadata: nil,
               idempotency_key: nil, attachments: nil, topic_id: nil,
               type: nil, unsubscribe_url: nil, headers: nil)
        body = {
          from: from,
          to: Array(to),
          subject: subject,
          html: html,
          text: text,
          cc: cc ? Array(cc) : nil,
          bcc: bcc ? Array(bcc) : nil,
          replyTo: reply_to,
          templateId: template_id,
          templateData: template_data,
          scheduledFor: scheduled_for,
          tags: tags,
          metadata: metadata,
          idempotencyKey: idempotency_key,
          attachments: attachments,
          topicId: topic_id,
          type: type,
          unsubscribeUrl: unsubscribe_url,
          headers: headers
        }
        @http.post("/v1/emails", body: body)
      end

      # Sends a batch of up to 100 emails.
      #
      # @param emails [Array<Hash>] array of email params
      # @return [Hash] batch result with per-email status
      def send_batch(emails)
        @http.post("/v1/emails/batch", body: { emails: emails })
      end

      # Lists emails with optional filters.
      #
      # @param limit [Integer, nil] max results (default 20, max 100)
      # @param cursor [String, nil] pagination cursor
      # @param status [String, nil] filter by status
      # @param tag [String, nil] filter by tag
      # @param after [String, nil] filter after date
      # @param before [String, nil] filter before date
      # @return [Hash] paginated list with :data, :hasMore, :nextCursor
      def list(limit: nil, cursor: nil, status: nil, tag: nil, after: nil, before: nil)
        query = { limit: limit, cursor: cursor, status: status, tag: tag, after: after, before: before }
        @http.get("/v1/emails", query: query)
      end

      # Gets a single email by ID.
      #
      # @param id [String] email ID
      # @return [Hash] email details
      def get(id)
        @http.get("/v1/emails/#{id}")
      end

      # Cancels a scheduled email.
      #
      # @param id [String] email ID
      # @return [Hash] cancellation result
      def cancel(id)
        @http.post("/v1/emails/#{id}/cancel")
      end

      # Reschedules a scheduled email.
      #
      # @param id [String] email ID
      # @param scheduled_for [String] new ISO 8601 scheduled time
      # @return [Hash] updated email
      def update(id, scheduled_for:)
        @http.patch("/v1/emails/#{id}", body: { scheduledFor: scheduled_for })
      end

      # Gets tracked link analytics for a specific email.
      #
      # @param id [String] email ID
      # @param limit [Integer, nil] max links to return
      # @param sort [String, nil] sort field
      # @param order [String, nil] sort order ('asc' or 'desc')
      # @return [Hash] link analytics data
      def links(id, limit: nil, sort: nil, order: nil)
        @http.get("/v1/emails/#{id}/links",
                  query: { limit: limit, sort: sort, order: order })
      end
    end
  end
end
