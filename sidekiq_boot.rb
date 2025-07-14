require 'bundler'
require 'dotenv/load'

Bundler.require

# Configure Sidekiq
Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

# Load application files
require './connections/redis'
require './lib/default_connector'
require './jobs/process_payment_job'
