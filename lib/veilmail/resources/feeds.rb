# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles RSS feed management.
    class Feeds
      def initialize(http)
        @http = http
      end

      # Creates a new RSS feed.
      #
      # @param name [String] feed name
      # @param url [String] RSS feed URL
      # @param audience_id [String] target audience ID
      # @param poll_interval [String] poll interval ('hourly', 'daily', 'weekly')
      # @param mode [String] feed mode ('single' or 'digest')
      # @param subject_template [String, nil] subject line template
      # @param html_template [String, nil] HTML template
      # @return [Hash] created feed
      def create(name:, url:, audience_id:, poll_interval: "daily", mode: "single",
                 subject_template: nil, html_template: nil)
        @http.post("/v1/feeds", body: {
          name: name,
          url: url,
          audienceId: audience_id,
          pollInterval: poll_interval,
          mode: mode,
          subjectTemplate: subject_template,
          htmlTemplate: html_template
        })
      end

      # Lists all RSS feeds.
      #
      # @return [Hash] response with feed data
      def list
        @http.get("/v1/feeds")
      end

      # Gets a single feed by ID.
      #
      # @param id [String] feed ID
      # @return [Hash] feed details with recent items
      def get(id)
        @http.get("/v1/feeds/#{id}")
      end

      # Updates a feed.
      #
      # @param id [String] feed ID
      # @return [Hash] updated feed
      def update(id, **params)
        body = {
          name: params[:name],
          url: params[:url],
          pollInterval: params[:poll_interval],
          mode: params[:mode],
          subjectTemplate: params[:subject_template],
          htmlTemplate: params[:html_template]
        }
        @http.put("/v1/feeds/#{id}", body: body)
      end

      # Deletes a feed and all its items.
      #
      # @param id [String] feed ID
      # @return [nil]
      def delete(id)
        @http.delete("/v1/feeds/#{id}")
        nil
      end

      # Manually triggers a feed poll.
      #
      # @param id [String] feed ID
      # @return [Hash] result with success and new_items count
      def poll(id)
        @http.post("/v1/feeds/#{id}/poll")
      end

      # Pauses an active feed.
      #
      # @param id [String] feed ID
      # @return [Hash] paused feed
      def pause(id)
        @http.post("/v1/feeds/#{id}/pause")
      end

      # Resumes a paused or errored feed.
      #
      # @param id [String] feed ID
      # @return [Hash] resumed feed
      def resume(id)
        @http.post("/v1/feeds/#{id}/resume")
      end

      # Lists feed items with pagination.
      #
      # @param feed_id [String] feed ID
      # @param limit [Integer, nil] max results
      # @param cursor [String, nil] pagination cursor
      # @param processed [Boolean, nil] filter by processed status
      # @return [Hash] paginated response
      def list_items(feed_id, limit: nil, cursor: nil, processed: nil)
        query = { limit: limit, cursor: cursor }
        query[:processed] = processed.to_s unless processed.nil?
        @http.get("/v1/feeds/#{feed_id}/items", query: query)
      end
    end
  end
end
