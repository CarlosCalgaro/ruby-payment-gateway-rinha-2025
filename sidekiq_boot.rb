require_relative 'application'

# Additional Sidekiq server configuration
Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end
