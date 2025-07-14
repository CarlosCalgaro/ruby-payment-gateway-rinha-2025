class DefaultConnector
  def initialize
    @conn = Faraday.new(
      url: ENV.fetch('DEFAULT_URL', 'http://localhost:8001'),
      headers: {'Content-Type' => 'application/json'}
    )
  end

  def process_payment()
    resp = @conn.post('/payments/')
  end

  def service_health()
    cached_health = REDIS.get('default_service_health')
    cached_health ? JSON.parse(cached_health) : fetch_service_health
  end


  private

  def fetch_service_health
    resp = @conn.get('/payments/service-health')
    REDIS.set('default_service_health', resp.body, ex: 5)
    JSON.parse resp.body
  end
end