
class ProcessPaymentJob
  include Sidekiq::Job
  sidekiq_options queue: 'payments', retry: false

  def perform(payment_data)
    File.write('log.txt', "Processing payment: #{payment_data}\n", mode: 'a')
  end
end