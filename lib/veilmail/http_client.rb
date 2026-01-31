# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module VeilMail
  # @api private
  class HttpClient
    DEFAULT_BASE_URL = "https://api.veilmail.xyz"
    DEFAULT_TIMEOUT = 30
    USER_AGENT = "veilmail-ruby/#{VERSION}"

    def initialize(api_key, base_url: nil, timeout: nil)
      @api_key = api_key
      @base_url = (base_url || DEFAULT_BASE_URL).chomp("/")
      @timeout = timeout || DEFAULT_TIMEOUT
    end

    def get(path, query: nil)
      request(:get, path, query: query)
    end

    def post(path, body: nil)
      request(:post, path, body: body)
    end

    def patch(path, body: nil)
      request(:patch, path, body: body)
    end

    def put(path, body: nil)
      request(:put, path, body: body)
    end

    def delete(path)
      request(:delete, path)
    end

    def get_raw(path, query: nil)
      request_raw(:get, path, query: query)
    end

    private

    def request(method, path, body: nil, query: nil)
      response = execute(method, path, body: body, query: query)
      parse_response(response)
    end

    def request_raw(method, path, query: nil)
      response = execute(method, path, query: query)
      handle_error(response) if response.code.to_i >= 400
      response.body
    end

    def execute(method, path, body: nil, query: nil)
      uri = build_uri(path, query)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = @timeout
      http.read_timeout = @timeout

      req = build_request(method, uri, body)
      http.request(req)
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      raise Error.new("Request timed out: #{e.message}", code: "timeout")
    rescue Errno::ECONNREFUSED, SocketError => e
      raise Error.new("Network error: #{e.message}", code: "network_error")
    end

    def build_uri(path, query)
      url = "#{@base_url}#{path}"
      uri = URI.parse(url)
      uri.query = URI.encode_www_form(query.compact) if query&.any?
      uri
    end

    def build_request(method, uri, body)
      klass = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        patch: Net::HTTP::Patch,
        put: Net::HTTP::Put,
        delete: Net::HTTP::Delete
      }.fetch(method)

      req = klass.new(uri)
      req["Authorization"] = "Bearer #{@api_key}"
      req["User-Agent"] = USER_AGENT
      req["Content-Type"] = "application/json" if body

      req.body = JSON.generate(compact_hash(body)) if body

      req
    end

    def parse_response(response)
      handle_error(response) if response.code.to_i >= 400
      return nil if response.body.nil? || response.body.empty?

      JSON.parse(response.body)
    end

    def handle_error(response)
      status = response.code.to_i
      body = begin
        JSON.parse(response.body)
      rescue StandardError
        {}
      end

      error_data = body["error"] || {}
      message = error_data["message"] || "An unknown error occurred"
      code = error_data["code"] || "unknown"
      details = error_data["details"]

      case status
      when 401
        raise AuthenticationError.new(message, code: code, details: details)
      when 403
        raise ForbiddenError.new(message, code: code, details: details)
      when 404
        raise NotFoundError.new(message, code: code, details: details)
      when 422
        pii_types = details&.dig("piiTypes") || []
        raise PiiDetectedError.new(message, code: code, details: details, pii_types: pii_types)
      when 429
        retry_after = response["Retry-After"]&.to_i
        raise RateLimitError.new(message, code: code, details: details, retry_after: retry_after)
      when 400
        raise ValidationError.new(message, code: code, details: details)
      when 500..599
        raise ServerError.new(message, code: code, status: status, details: details)
      else
        raise Error.new(message, code: code, status: status, details: details)
      end
    end

    def compact_hash(hash)
      return hash unless hash.is_a?(Hash)

      hash.each_with_object({}) do |(key, value), result|
        next if value.nil?

        result[key] = value.is_a?(Hash) ? compact_hash(value) : value
      end
    end
  end
end
