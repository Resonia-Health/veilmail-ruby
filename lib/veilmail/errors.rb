# frozen_string_literal: true

module VeilMail
  # Base error class for all Veil Mail API errors.
  class Error < StandardError
    attr_reader :code, :status, :details

    def initialize(message, code: nil, status: nil, details: nil)
      @code = code
      @status = status
      @details = details
      super(message)
    end
  end

  # Raised when the API key is invalid or missing (401).
  class AuthenticationError < Error
    def initialize(message = "Invalid API key", **kwargs)
      super(message, status: 401, **kwargs)
    end
  end

  # Raised when access is denied (403).
  class ForbiddenError < Error
    def initialize(message = "Access denied", **kwargs)
      super(message, status: 403, **kwargs)
    end
  end

  # Raised when the requested resource is not found (404).
  class NotFoundError < Error
    def initialize(message = "Resource not found", **kwargs)
      super(message, status: 404, **kwargs)
    end
  end

  # Raised when request validation fails (400).
  class ValidationError < Error
    def initialize(message = "Validation failed", **kwargs)
      super(message, status: 400, **kwargs)
    end
  end

  # Raised when PII is detected in email content (422).
  class PiiDetectedError < Error
    attr_reader :pii_types

    def initialize(message = "PII detected", pii_types: [], **kwargs)
      @pii_types = pii_types
      super(message, status: 422, **kwargs)
    end
  end

  # Raised when the rate limit is exceeded (429).
  class RateLimitError < Error
    attr_reader :retry_after

    def initialize(message = "Rate limit exceeded", retry_after: nil, **kwargs)
      @retry_after = retry_after
      super(message, status: 429, **kwargs)
    end
  end

  # Raised for server errors (5xx).
  class ServerError < Error
    def initialize(message = "Server error", **kwargs)
      super(message, **kwargs)
    end
  end
end
