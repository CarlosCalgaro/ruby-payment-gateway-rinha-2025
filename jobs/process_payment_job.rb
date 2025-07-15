
class ProcessPaymentJob
  include Sidekiq::Job
  sidekiq_options queue: 'payments', retry: false

  def perform(payment_data)
    puts "Processing payment: #{payment_data.to_json}"

    connector = DefaultConnector.new
    unless connector.service_health['failing']
      begin
        connector.process_payment(payment_data['correlationId'], payment_data['amount'])
      rescue Faraday::TooManyRequestsError=> e
        Sidekiq::Job.retry_in(1) { self.class.perform_async(payment_data) }
        LOGGER.error("Too many requests while processing payment: #{e.message}")
      rescue Faraday::ConnectionFailedError => e
        Sidekiq::Job.retry_in(5) { self.class.perform_async(payment_data) }
        LOGGER.error("Connection failed while processing payment: #{e.message}")
      ensure
      end
    end

    puts "Payment processed successfully: #{payment_data['correlationId']}"
  end
end