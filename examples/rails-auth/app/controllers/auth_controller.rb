# app/controllers/auth_controller.rb

class AuthController < ApplicationController
  skip_before_action :authenticate!, only: %i[register login verify_email forgot_password reset_password verify_2fa]

  def register
    user = User.new(user_params)
    user.password = params[:password]

    if user.save
      token = user.generate_verification_token!
      AuthMailer.new.send_verification_email(user, token)
      render json: { message: 'Verification email sent' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def verify_email
    record = VerificationToken.find_by(token: params[:token])

    if record.nil?
      return render json: { error: 'Invalid token' }, status: :bad_request
    end

    if record.expires_at < Time.current
      return render json: { error: 'Token expired' }, status: :bad_request
    end

    user = User.find_by(email: record.email)
    user.update!(email_verified: true)
    record.destroy!

    AuthMailer.new.send_welcome_email(user)
    render json: { message: 'Email verified' }
  end

  def login
    user = User.find_by(email: params[:email])

    unless user&.authenticate(params[:password])
      return render json: { error: 'Invalid credentials' }, status: :unauthorized
    end

    unless user.email_verified?
      token = user.generate_verification_token!
      AuthMailer.new.send_verification_email(user, token)
      return render json: { error: 'Email not verified. Verification email resent.' }, status: :forbidden
    end

    if user.two_factor_enabled?
      code = user.generate_two_factor_code!
      AuthMailer.new.send_two_factor_code(user, code)
      return render json: { two_factor_required: true }
    end

    token = user.generate_jwt
    render json: { access_token: token, token_type: 'bearer' }
  end

  def verify_2fa
    user = User.find_by(email: params[:email])

    unless user&.authenticate(params[:password])
      return render json: { error: 'Invalid credentials' }, status: :unauthorized
    end

    record = TwoFactorToken.find_by(email: user.email, code: params[:code])

    if record.nil?
      return render json: { error: 'Invalid code' }, status: :bad_request
    end

    if record.expires_at < Time.current
      return render json: { error: 'Code expired' }, status: :bad_request
    end

    record.destroy!
    token = user.generate_jwt
    render json: { access_token: token, token_type: 'bearer' }
  end

  def forgot_password
    user = User.find_by(email: params[:email])

    if user
      token = user.generate_password_reset_token!
      AuthMailer.new.send_password_reset_email(user, token)
    end

    render json: { message: 'If an account exists, a reset email has been sent' }
  end

  def reset_password
    record = PasswordResetToken.find_by(token: params[:token])

    if record.nil?
      return render json: { error: 'Invalid token' }, status: :bad_request
    end

    if record.expires_at < Time.current
      return render json: { error: 'Token expired' }, status: :bad_request
    end

    user = User.find_by(email: record.email)
    user.update!(password: params[:password])
    record.destroy!

    AuthMailer.new.send_password_changed_email(user)
    render json: { message: 'Password updated' }
  end

  private

  def user_params
    params.permit(:name, :email)
  end
end
