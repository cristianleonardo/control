Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDISTOGO_URL", "redis://localhost:6379"), namespace: "SAPSB_sidekiq_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDISTOGO_URL", "redis://localhost:6379"), namespace: "SAPSB_sidekiq_#{Rails.env}" }
end
