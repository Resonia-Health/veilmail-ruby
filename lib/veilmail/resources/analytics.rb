# frozen_string_literal: true

module VeilMail
  module Resources
    # Handles geo and device analytics.
    class Analytics
      def initialize(http)
        @http = http
      end

      # Gets organization-level geo analytics.
      #
      # @param days [Integer, nil] number of days to look back (max 90, default 30)
      # @param event_type [String, nil] filter by event type ('OPENED' or 'CLICKED')
      # @return [Hash] geo analytics data
      def geo(days: nil, event_type: nil)
        @http.get("/v1/analytics/geo", query: { days: days, eventType: event_type })
      end

      # Gets organization-level device analytics.
      #
      # @param days [Integer, nil] number of days to look back (max 90, default 30)
      # @param event_type [String, nil] filter by event type ('OPENED' or 'CLICKED')
      # @return [Hash] device analytics data
      def devices(days: nil, event_type: nil)
        @http.get("/v1/analytics/devices", query: { days: days, eventType: event_type })
      end

      # Gets campaign-level geo analytics.
      #
      # @param campaign_id [String] campaign ID
      # @param event_type [String, nil] filter by event type
      # @return [Hash] campaign geo analytics data
      def campaign_geo(campaign_id, event_type: nil)
        @http.get("/v1/campaigns/#{campaign_id}/analytics/geo",
                  query: { eventType: event_type })
      end

      # Gets campaign-level device analytics.
      #
      # @param campaign_id [String] campaign ID
      # @param event_type [String, nil] filter by event type
      # @return [Hash] campaign device analytics data
      def campaign_devices(campaign_id, event_type: nil)
        @http.get("/v1/campaigns/#{campaign_id}/analytics/devices",
                  query: { eventType: event_type })
      end
    end
  end
end
