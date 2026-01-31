# app/mailers/auth_mailer.rb
#
# VeilMail-powered auth mailer. Uses the VeilMail SDK directly
# instead of ActionMailer's SMTP delivery for better deliverability
# and tracking via tags.

class AuthMailer
  def initialize
    @client = VeilMail::Client.new(api_key: ENV.fetch('VEILMAIL_API_KEY'))
    @from = ENV.fetch('VEILMAIL_FROM_EMAIL', 'noreply@veilmail.xyz')
    @app_url = ENV.fetch('APP_URL', 'http://localhost:3000')
  end

  def send_verification_email(user, token)
    url = "#{@app_url}/auth/verify_email?token=#{token}"
    @client.emails.send(
      from: @from,
      to: user.email,
      subject: 'Verify your email address',
      html: "<p>Hi #{user.name},</p><p>Click <a href=\"#{url}\">here</a> to verify your email. This link expires in 1 hour.</p>",
      tags: %w[auth verification],
      type: 'transactional'
    )
  end

  def send_password_reset_email(user, token)
    url = "#{@app_url}/auth/reset_password?token=#{token}"
    @client.emails.send(
      from: @from,
      to: user.email,
      subject: 'Reset your password',
      html: "<p>Click <a href=\"#{url}\">here</a> to reset your password. This link expires in 1 hour.</p>",
      tags: %w[auth password-reset],
      type: 'transactional'
    )
  end

  def send_two_factor_code(user, code)
    @client.emails.send(
      from: @from,
      to: user.email,
      subject: "#{code} is your verification code",
      html: "<p>Your code: <strong>#{code}</strong></p><p>Expires in 5 minutes.</p>",
      tags: %w[auth 2fa],
      type: 'transactional'
    )
  end

  def send_welcome_email(user)
    @client.emails.send(
      from: @from,
      to: user.email,
      subject: 'Welcome!',
      html: "<p>Welcome, #{user.name}! Your account is active.</p>",
      tags: %w[auth welcome],
      type: 'transactional'
    )
  end

  def send_password_changed_email(user)
    @client.emails.send(
      from: @from,
      to: user.email,
      subject: 'Your password was changed',
      html: '<p>Your password was changed. If you didn\'t do this, reset it immediately.</p>',
      tags: %w[auth security],
      type: 'transactional'
    )
  end

  def send_two_factor_toggled_email(user, enabled)
    status = enabled ? 'enabled' : 'disabled'
    @client.emails.send(
      from: @from,
      to: user.email,
      subject: "Two-factor authentication #{status}",
      html: "<p>2FA has been #{status} on your account.</p>",
      tags: %w[auth 2fa security],
      type: 'transactional'
    )
  end
end
