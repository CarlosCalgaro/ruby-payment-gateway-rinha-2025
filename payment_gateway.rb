require 'sinatra/base'
require 'sinatra/json'

class PaymentGateway < Sinatra::Base

  post '/payments' do
    data = JSON.parse request.body.read
    ProcessPaymentJob.perform_async(data) # Enqueue the job to process payment
    json data
  end

  get '/payments-summary' do
    
  end
end