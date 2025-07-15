class DefaultConnector

  CONNECTOR_NAME = 'default'

  def initialize
    @conn = Faraday.new(
      url: ENV.fetch('DEFAULT_URL', 'http://localhost:8001'),
      headers: {'Content-Type' => 'application/json'}
    ) do |builder|
      builder.response :raise_error
    end
  end

  def process_payment(correlation_id, amount)
    resp = @conn.post('/payments/') do |req|
      req.body =  {
        correlationId: correlation_id,
        amount: amount
      }.to_json
    end
    Sequel::Model.db[:payments].insert(
      gateway: CONNECTOR_NAME,
      amount: amount
    )
  end

  def service_health()
    cached_health = REDIS.get('default_service_health')
    cached_health ? JSON.parse(cached_health) : fetch_service_health
  end


  private

  def fetch_service_health
    resp = @conn.get('/payments/service-health')
    REDIS.set('default_service_health', resp.body, ex: 5.1)
    JSON.parse resp.body
  end
end