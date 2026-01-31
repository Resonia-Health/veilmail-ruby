# Rails Authentication with VeilMail

A minimal Rails 8 example showing email verification, password reset, two-factor authentication, and security notifications powered by the VeilMail Ruby SDK.

## What's Included

- **Email verification** on signup with token expiry
- **Password reset** flow with secure tokens
- **Two-factor authentication** via email codes
- **Security notifications** for password changes and 2FA toggle

## Key Files

These are the files you would add to a standard Rails app:

| File | Purpose |
|------|---------|
| `app/mailers/auth_mailer.rb` | VeilMail SDK integration for all auth emails |
| `app/controllers/auth_controller.rb` | Registration, login, verification, password reset |
| `app/controllers/users_controller.rb` | Profile and 2FA toggle |
| `app/models/user.rb` | User model with token generation helpers |
| `db/migrate/001_create_auth_tables.rb` | Users and token tables |
| `config/routes.rb` | Auth and user routes |

## Setup

1. Add VeilMail to your Gemfile and install:

```bash
bundle add veilmail
```

2. Set environment variables:

```bash
export VEILMAIL_API_KEY="veil_live_xxx"
export VEILMAIL_FROM_EMAIL="noreply@yourdomain.com"
export APP_URL="https://yourdomain.com"
export SECRET_KEY="your-secret-key"
```

3. Run the migration:

```bash
bin/rails db:migrate
```

4. Start the server:

```bash
bin/rails server
```

## API Endpoints

```
POST /auth/register          - Create account (sends verification email)
GET  /auth/verify_email      - Verify email with token
POST /auth/login             - Login (triggers 2FA if enabled)
POST /auth/verify_2fa        - Complete login with 2FA code
POST /auth/forgot_password   - Request password reset email
POST /auth/reset_password    - Reset password with token
GET  /users/me               - Get current user profile (protected)
POST /users/toggle_2fa       - Enable/disable 2FA (protected)
```
