#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'securerandom'

# Configuration
BASE_URL = 'http://localhost:9999'
ENDPOINT = '/payments'

def generate_random_payment
  {
    correlationId: SecureRandom.uuid,
    amount: (rand(1..1000) + rand.round(2)).round(2)
  }
end

def fire_transaction(payment_data)
  uri = URI("#{BASE_URL}#{ENDPOINT}")
  
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri)
  request['Content-Type'] = 'application/json'
  request.body = payment_data.to_json
  
  puts "🚀 Firing transaction: #{payment_data.to_json}"
  
  begin
    response = http.request(request)
    puts "✅ Response (#{response.code}): #{response.body}"
    puts "─" * 60
    return response
  rescue => e
    puts "❌ Error: #{e.message}"
    puts "─" * 60
    return nil
  end
end

def main
  if ARGV.include?('--help') || ARGV.include?('-h')
    puts <<~HELP
      Usage: ruby fire_transaction.rb [OPTIONS]
      
      Fire random payment transactions to the payment gateway
      
      Options:
        --count, -c NUMBER    Number of transactions to fire (default: 1)
        --interval, -i SECONDS  Interval between transactions (default: 1)
        --continuous          Fire transactions continuously (Ctrl+C to stop)
        --help, -h            Show this help message
      
      Examples:
        ruby fire_transaction.rb                    # Fire 1 transaction
        ruby fire_transaction.rb -c 5               # Fire 5 transactions
        ruby fire_transaction.rb -c 10 -i 0.5       # Fire 10 transactions with 0.5s interval
        ruby fire_transaction.rb --continuous -i 2  # Fire continuously every 2 seconds
    HELP
    exit 0
  end
  
  count = 1
  interval = 1
  continuous = false
  
  # Parse command line arguments
  i = 0
  while i < ARGV.length
    case ARGV[i]
    when '--count', '-c'
      count = ARGV[i + 1].to_i
      i += 2
    when '--interval', '-i'
      interval = ARGV[i + 1].to_f
      i += 2
    when '--continuous'
      continuous = true
      i += 1
    else
      i += 1
    end
  end
  
  puts "🎯 Payment Transaction Generator"
  puts "Target: #{BASE_URL}#{ENDPOINT}"
  puts "Mode: #{continuous ? 'Continuous' : "#{count} transactions"}"
  puts "Interval: #{interval}s"
  puts "=" * 60
  
  transaction_count = 0
  
  begin
    loop do
      payment_data = generate_random_payment
      response = fire_transaction(payment_data)
      
      transaction_count += 1
      
      if response && response.code.to_i >= 200 && response.code.to_i < 300
        puts "📊 Total successful transactions: #{transaction_count}"
      end
      
      break if !continuous && transaction_count >= count
      
      sleep(interval) if continuous || transaction_count < count
    end
  rescue Interrupt
    puts "\n\n🛑 Stopping transaction generator..."
    puts "📊 Total transactions fired: #{transaction_count}"
  end
  
  puts "\n✨ Transaction generator finished!"
end

if __FILE__ == $0
  main
end
