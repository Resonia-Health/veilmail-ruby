# config/routes.rb

Rails.application.routes.draw do
  # Auth
  post 'auth/register', to: 'auth#register'
  get  'auth/verify_email', to: 'auth#verify_email'
  post 'auth/login', to: 'auth#login'
  post 'auth/verify_2fa', to: 'auth#verify_2fa'
  post 'auth/forgot_password', to: 'auth#forgot_password'
  post 'auth/reset_password', to: 'auth#reset_password'

  # Users (protected)
  get  'users/me', to: 'users#me'
  post 'users/toggle_2fa', to: 'users#toggle_2fa'
end
