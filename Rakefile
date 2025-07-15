require 'dotenv/load'
require 'sequel'

# Load environment variables
Dotenv.load

namespace :db do
  task :create do
    # Connect to postgres system database to create the payment_gateway database
    system_db_url = ENV.fetch('CONNECTION_URL').gsub('/payment_gateway', '/postgres')
    system_db = Sequel.connect(system_db_url)
    
    begin
      system_db.execute "DROP DATABASE IF EXISTS payment_gateway"
      system_db.execute "CREATE DATABASE payment_gateway"
      puts "Database 'payment_gateway' created successfully!"
    rescue => e
      puts "Error creating database: #{e.message}"
    ensure
      system_db.disconnect
    end
  end

  task :migrate do
    require_relative 'db/db'
    Sequel.extension :migration
    Sequel::Migrator.run(DATABASE, 'db/migrations', use_transactions: true)
    puts "Migrations completed successfully!"
  end

  task :setup => [:create, :migrate] do
    puts "Database setup completed!"
  end
end

namespace :sidekiq do
  desc "Start Sidekiq worker"
  task :start do
    require 'sidekiq/cli'
    exec("bundle exec sidekiq -r ./sidekiq_boot.rb -C config/sidekiq.yml")
  end
end

task :default => :setup
