# frozen_string_literal: true

require_relative "veilmail/version"
require_relative "veilmail/errors"
require_relative "veilmail/http_client"
require_relative "veilmail/webhook"
require_relative "veilmail/resources/emails"
require_relative "veilmail/resources/domains"
require_relative "veilmail/resources/templates"
require_relative "veilmail/resources/audiences"
require_relative "veilmail/resources/campaigns"
require_relative "veilmail/resources/webhooks"
require_relative "veilmail/resources/topics"
require_relative "veilmail/resources/properties"
require_relative "veilmail/resources/sequences"
require_relative "veilmail/resources/feeds"
require_relative "veilmail/resources/forms"
require_relative "veilmail/resources/analytics"
require_relative "veilmail/client"

module VeilMail
end
