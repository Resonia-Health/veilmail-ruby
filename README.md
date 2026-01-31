# Veil Mail Ruby SDK

Official Ruby SDK for the [Veil Mail](https://veilmail.xyz) API. Send emails with built-in PII protection.

## Requirements

- Ruby 3.0+

## Installation

Add to your Gemfile:

```ruby
gem "veilmail"
```

Or install directly:

```bash
gem install veilmail
```

## Quick Start

```ruby
require "veilmail"

client = VeilMail::Client.new("veil_live_xxxxx")

email = client.emails.send(
  from: "hello@yourdomain.com",
  to: "user@example.com",
  subject: "Hello from Ruby!",
  html: "<h1>Welcome!</h1>"
)

puts email["id"]     # email_xxxxx
puts email["status"] # queued
```

## Configuration

```ruby
client = VeilMail::Client.new(
  "veil_live_xxxxx",
  base_url: "https://custom-api.example.com",
  timeout: 10
)
```

## Emails

```ruby
# Send with named sender
email = client.emails.send(
  from: "Alice <alice@yourdomain.com>",
  to: ["bob@example.com"],
  subject: "Hello",
  html: "<p>Hello Bob!</p>",
  tags: ["welcome"]
)

# Send with template
email = client.emails.send(
  from: "hello@yourdomain.com",
  to: "user@example.com",
  template_id: "tmpl_xxx",
  template_data: { name: "Alice" }
)

# Send with attachments
email = client.emails.send(
  from: "hello@yourdomain.com",
  to: "user@example.com",
  subject: "Invoice",
  html: "<p>Attached is your invoice.</p>",
  attachments: [
    { filename: "invoice.pdf", content: base64_content, contentType: "application/pdf" }
  ]
)

# Batch send (up to 100)
result = client.emails.send_batch([
  { from: "hello@yourdomain.com", to: ["user1@example.com"], subject: "Hi", html: "<p>Hi!</p>" },
  { from: "hello@yourdomain.com", to: ["user2@example.com"], subject: "Hi", html: "<p>Hi!</p>" }
])

# List, get, cancel, reschedule
emails = client.emails.list(status: "delivered", limit: 10)
email = client.emails.get("email_xxx")
result = client.emails.cancel("email_xxx")
email = client.emails.update("email_xxx", scheduled_for: "2025-07-01T09:00:00Z")
```

## Domains

```ruby
# Add and verify a domain
domain = client.domains.create(domain: "mail.example.com")
domain = client.domains.verify(domain["id"])

# Update tracking
domain = client.domains.update(domain["id"], track_opens: true, track_clicks: true)

# List and delete
domains = client.domains.list
client.domains.delete(domain["id"])
```

## Templates

```ruby
tmpl = client.templates.create(
  name: "Welcome",
  subject: "Welcome, {{name}}!",
  html: "<h1>Hello {{name}}</h1>",
  variables: [{ name: "name", type: "string", required: true }]
)

# Preview
preview = client.templates.preview(
  html: "<h1>Hello {{name}}</h1>",
  variables: { name: "Alice" }
)
```

## Audiences & Subscribers

```ruby
audience = client.audiences.create(name: "Newsletter")
subs = client.audiences.subscribers(audience["id"])

# Add subscriber
subscriber = subs.add(
  email: "user@example.com",
  first_name: "Alice",
  last_name: "Smith"
)

# List, import, export
subscribers = subs.list(status: "active", limit: 50)
result = subs.import(csv_data: "email,firstName\nuser@example.com,Bob")
csv = subs.export(status: "active")

# Activity timeline
events = subs.activity(subscriber["id"], limit: 20)
```

## Campaigns

```ruby
campaign = client.campaigns.create(
  name: "Summer Sale",
  subject: "50% Off!",
  from: "Store <deals@yourdomain.com>",
  audience_id: "aud_xxx",
  html: "<h1>Summer Sale!</h1>"
)

# Schedule, send, pause, resume, cancel
client.campaigns.schedule(campaign["id"], scheduled_at: "2025-06-15T10:00:00Z")
client.campaigns.send_now(campaign["id"])
client.campaigns.pause(campaign["id"])
client.campaigns.resume(campaign["id"])
client.campaigns.cancel(campaign["id"])
```

## Webhooks

```ruby
webhook = client.webhooks.create(
  url: "https://yourdomain.com/webhooks/veilmail",
  events: ["email.delivered", "email.bounced"]
)

# Test and rotate secret
result = client.webhooks.test(webhook["id"])
webhook = client.webhooks.rotate_secret(webhook["id"])
```

### Signature Verification

```ruby
# In a Rails controller
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def veilmail
    body = request.raw_post
    signature = request.headers["X-Signature-Hash"]

    unless VeilMail::Webhook.verify_signature(body, signature, ENV["WEBHOOK_SECRET"])
      head :unauthorized
      return
    end

    event = JSON.parse(body)
    case event["type"]
    when "email.delivered"
      # Handle delivery
    when "email.bounced"
      # Handle bounce
    end

    head :ok
  end
end
```

## Topics

```ruby
topic = client.topics.create(name: "Product Updates", is_default: true)
topics = client.topics.list(active: true)

# Subscriber preferences
prefs = client.topics.get_preferences("aud_xxx", "sub_xxx")
client.topics.set_preferences("aud_xxx", "sub_xxx",
  topics: [
    { topic_id: "topic_xxx", subscribed: true },
    { topic_id: "topic_yyy", subscribed: false }
  ]
)
```

## Contact Properties

```ruby
prop = client.properties.create(key: "company", name: "Company Name", type: "text")

# Set values for a subscriber
client.properties.set_values("aud_xxx", "sub_xxx", { "company" => "Acme Corp" })
values = client.properties.get_values("aud_xxx", "sub_xxx")
```

## Error Handling

```ruby
begin
  client.emails.send(from: "hello@yourdomain.com", to: "user@example.com", subject: "Hi", html: "<p>Hi</p>")
rescue VeilMail::AuthenticationError
  puts "Invalid API key"
rescue VeilMail::PiiDetectedError => e
  puts "PII detected: #{e.pii_types}"
rescue VeilMail::RateLimitError => e
  puts "Rate limited, retry after #{e.retry_after}s"
rescue VeilMail::ValidationError => e
  puts "Validation error: #{e.message}"
rescue VeilMail::NotFoundError
  puts "Not found"
rescue VeilMail::Error => e
  puts "API error: #{e.message} (code: #{e.code})"
end
```

## License

MIT
