OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '1022710274932-2d5it0ja1sc0k0pihnq59hocbcu5h4lk.apps.googleusercontent.com', '64pMMvaQ-5BBGcqH5hCqOyn2', {
      access_type: 'offline',
      scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar',
      #redirect_uri:'http://127.0.0.1/auth/google_oauth2/callback'
  }
end