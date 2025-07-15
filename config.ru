require_relative 'application'

# Session configuration
require 'securerandom'
File.open(".session.key", "w") { |f| f.write(SecureRandom.hex(32)) } unless File.exist?(".session.key")

# Middleware
use Rack::Session::Cookie, 
    secret: File.read(".session.key"), 
    same_site: true, 
    max_age: 86400

# Mount applications
run Rack::URLMap.new(
  '/' => PaymentGateway,
  '/sidekiq' => Sidekiq::Web
)