# app/controllers/users_controller.rb

class UsersController < ApplicationController
  def me
    render json: {
      id: current_user.id,
      email: current_user.email,
      name: current_user.name,
      email_verified: current_user.email_verified?,
      two_factor_enabled: current_user.two_factor_enabled?
    }
  end

  def toggle_2fa
    current_user.update!(two_factor_enabled: !current_user.two_factor_enabled?)

    AuthMailer.new.send_two_factor_toggled_email(current_user, current_user.two_factor_enabled?)

    render json: {
      two_factor_enabled: current_user.two_factor_enabled?,
      message: "2FA #{current_user.two_factor_enabled? ? 'enabled' : 'disabled'}"
    }
  end
end
