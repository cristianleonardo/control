if Rails.env == 'production' || Rails.env == 'staging'
  Raven.configure do |config|
    config.dsn = "https://#{Rails.application.secrets.sentry_key}:#{Rails.application.secrets.sentry_secret}@sentry.io/135629"
    config.environments = ['production', 'staging']
  end
end
