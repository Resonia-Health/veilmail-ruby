# frozen_string_literal: true

module VeilMail
  # The main Veil Mail API client.
  #
  # @example
  #   client = VeilMail::Client.new("veil_live_xxxxx")
  #   email = client.emails.send(
  #     from: "hello@yourdomain.com",
  #     to: "user@example.com",
  #     subject: "Hello!",
  #     html: "<p>Welcome!</p>"
  #   )
  class Client
    # @return [Resources::Emails]
    attr_reader :emails

    # @return [Resources::Domains]
    attr_reader :domains

    # @return [Resources::Templates]
    attr_reader :templates

    # @return [Resources::Audiences]
    attr_reader :audiences

    # @return [Resources::Campaigns]
    attr_reader :campaigns

    # @return [Resources::Webhooks]
    attr_reader :webhooks

    # @return [Resources::Topics]
    attr_reader :topics

    # @return [Resources::Properties]
    attr_reader :properties

    # @return [Resources::Sequences]
    attr_reader :sequences

    # @return [Resources::Feeds]
    attr_reader :feeds

    # @return [Resources::Forms]
    attr_reader :forms

    # @return [Resources::Analytics]
    attr_reader :analytics

    # Creates a new Veil Mail client.
    #
    # @param api_key [String] Your API key (must start with "veil_live_" or "veil_test_")
    # @param base_url [String, nil] Custom API base URL
    # @param timeout [Integer, nil] Request timeout in seconds (default: 30)
    # @raise [ArgumentError] if the API key format is invalid
    def initialize(api_key, base_url: nil, timeout: nil)
      unless api_key.start_with?("veil_live_") || api_key.start_with?("veil_test_")
        raise ArgumentError, "Invalid API key format. Must start with 'veil_live_' or 'veil_test_'"
      end

      http = HttpClient.new(api_key, base_url: base_url, timeout: timeout)

      @emails = Resources::Emails.new(http)
      @domains = Resources::Domains.new(http)
      @templates = Resources::Templates.new(http)
      @audiences = Resources::Audiences.new(http)
      @campaigns = Resources::Campaigns.new(http)
      @webhooks = Resources::Webhooks.new(http)
      @topics = Resources::Topics.new(http)
      @properties = Resources::Properties.new(http)
      @sequences = Resources::Sequences.new(http)
      @feeds = Resources::Feeds.new(http)
      @forms = Resources::Forms.new(http)
      @analytics = Resources::Analytics.new(http)
    end
  end
end
