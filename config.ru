require 'bundler'
require 'dotenv/load'

Bundler.require

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

require './payment_gateway.rb'
require './lib/default_connector'
require './connections/redis'
require './jobs/process_payment_job'
require 'sidekiq/web'

# first, use IRB to create a shared secret key for sessions and commit it
require 'securerandom'; File.open(".session.key", "w") {|f| f.write(SecureRandom.hex(32)) }

# now use the secret with a session cookie middleware
use Rack::Session::Cookie, secret: File.read(".session.key"), same_site: true, max_age: 86400

run Rack::URLMap.new('/' => PaymentGateway, '/sidekiq' => Sidekiq::Web)