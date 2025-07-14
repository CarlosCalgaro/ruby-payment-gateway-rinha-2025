require 'bundler'
require 'dotenv/load'

Bundler.require

# Load environment variables
Dotenv.load

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

namespace :sidekiq do
  desc "Start Sidekiq worker"
  task :start do
    require 'sidekiq/cli'
    cli = Sidekiq::CLI.instance
    cli.parse(['sidekiq', '-C', 'config/sidekiq.yml'])
    cli.run
  end

  desc "Stop Sidekiq worker"
  task :stop do
    system("pkill -f sidekiq")
  end

  desc "Restart Sidekiq worker"
  task :restart => [:stop, :start]

  desc "Show Sidekiq stats"
  task :stats do
    require 'sidekiq/api'
    stats = Sidekiq::Stats.new
    puts "Processed: #{stats.processed}"
    puts "Failed: #{stats.failed}"
    puts "Busy: #{stats.workers_size}"
    puts "Enqueued: #{stats.enqueued}"
    puts "Scheduled: #{stats.scheduled_size}"
    puts "Retries: #{stats.retry_size}"
    puts "Dead: #{stats.dead_size}"
  end

  desc "Clear all Sidekiq queues"
  task :clear do
    require 'sidekiq/api'
    Sidekiq::Queue.new('payments').clear
    Sidekiq::Queue.new('default').clear
    puts "All queues cleared"
  end
end

namespace :app do
  desc "Start the web application on port 9999"
  task :start do
    system("rackup config.ru -p 9999")
  end

  desc "Start Redis via Docker"
  task :redis do
    system("docker-compose up -d redis")
  end

  desc "Stop all services"
  task :stop do
    system("docker-compose down")
    system("pkill -f rackup")
    system("pkill -f sidekiq")
  end
end

task :default => :setup
