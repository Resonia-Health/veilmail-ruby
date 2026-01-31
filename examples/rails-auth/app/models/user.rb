# app/models/user.rb

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def generate_verification_token!
    VerificationToken.where(email: email).destroy_all
    token = SecureRandom.urlsafe_base64(32)
    VerificationToken.create!(email: email, token: token, expires_at: 1.hour.from_now)
    token
  end

  def generate_password_reset_token!
    PasswordResetToken.where(email: email).destroy_all
    token = SecureRandom.urlsafe_base64(32)
    PasswordResetToken.create!(email: email, token: token, expires_at: 1.hour.from_now)
    token
  end

  def generate_two_factor_code!
    TwoFactorToken.where(email: email).destroy_all
    code = SecureRandom.random_number(900_000).+(100_000).to_s
    TwoFactorToken.create!(email: email, code: code, expires_at: 5.minutes.from_now)
    code
  end

  def generate_jwt
    payload = { sub: id.to_s, email: email, exp: 30.minutes.from_now.to_i }
    JWT.encode(payload, ENV.fetch('SECRET_KEY'), 'HS256')
  end
end
