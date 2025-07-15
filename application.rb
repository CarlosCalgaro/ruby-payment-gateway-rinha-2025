require 'bundler'
require 'dotenv/load'

# Load environment variables first
Dotenv.load

# Setup bundler
Bundler.require

# Configure Sidekiq
Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

# Load database connection
require_relative 'db/db'
require_relative 'db/redis'

# Set up Sequel Model database connection
Sequel::Model.db = DATABASE

# Load initializers
Dir[File.join(__dir__, 'initializers', '*.rb')].each { |file| require file }

# Load all models
Dir[File.join(__dir__, 'db', 'models', '*.rb')].each { |file| require file }

# Load all jobs
Dir[File.join(__dir__, 'jobs', '*.rb')].each { |file| require file }

# Load all lib files
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }

# Load all connections
Dir[File.join(__dir__, 'connections', '*.rb')].each { |file| require file }

# Load main application
require_relative 'payment_gateway'

# Load Sidekiq Web UI
require 'sidekiq/web'
