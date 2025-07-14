# Payment Gateway Service

A high-performance Ruby payment processing service built with Sinatra, Sidekiq, and Redis. This service provides asynchronous payment processing with background job queuing and external service integration.

## 🏗️ Architecture

- **Web Layer**: Sinatra-based REST API
- **Background Processing**: Sidekiq for asynchronous job processing
- **Cache/Queue**: Redis for job queuing and caching
- **External Integration**: Faraday HTTP client for external payment processors
- **Monitoring**: Sidekiq Web UI for job monitoring

## 📋 Features

- ✅ Asynchronous payment processing
- ✅ Background job queuing with Sidekiq
- ✅ External payment service integration
- ✅ Service health monitoring with caching
- ✅ Sidekiq Web UI for monitoring jobs
- ✅ Docker support for Redis
- ✅ Environment-based configuration

## 🚀 Quick Start

### Prerequisites

- Ruby 3.3.0+
- Docker and Docker Compose
- Bundler

### Installation

1. **Clone and setup**:
   ```bash
   cd solucao
   bundle install
   ```

2. **Start all services**:
   ```bash
   rake setup
   ```

3. **Start background worker** (in a new terminal):
   ```bash
   rake sidekiq:start
   ```

4. **Start web application** (in another terminal):
   ```bash
   rake app:start
   ```

The application will be running on **http://localhost:9999**

## 🛠️ Available Rake Tasks

### Application Management
```bash
rake setup                # Setup and start Redis
rake app:start            # Start web application on port 9999
rake app:redis            # Start Redis via Docker
rake app:stop             # Stop all services
```

### Sidekiq Management
```bash
rake sidekiq:start        # Start Sidekiq worker
rake sidekiq:stop         # Stop Sidekiq worker
rake sidekiq:restart      # Restart Sidekiq worker
rake sidekiq:stats        # Show job processing stats
rake sidekiq:clear        # Clear all job queues
```

## 📡 API Endpoints

### Payment Processing
```http
POST /payments
Content-Type: application/json

{
  "correlationId": "uuid-here",
  "amount": 19.99,
  "currency": "USD",
  "paymentMethod": "credit_card"
}
```

**Response**: Returns the payment data immediately while processing happens in the background.

### Payment Summary
```http
GET /payments-summary
```

### Sidekiq Monitoring
Visit **http://localhost:9999/sidekiq** to access the Sidekiq Web UI for monitoring background jobs.

## ⚙️ Configuration

### Environment Variables

Create a `.env` file or export these variables:

```bash
# External payment service URLs
DEFAULT_URL=http://localhost:8001
FALLBACK_URL=http://localhost:8002

# Redis configuration
REDIS_URL=redis://localhost:6379/11
```

### Sidekiq Configuration

Located in `config/sidekiq.yml`:
- **Concurrency**: 10 workers
- **Queues**: `payments` (priority), `default`
- **Retry**: Disabled for payment jobs (configured per job)

## 🔧 Development

### Running Individual Components

1. **Redis only**:
   ```bash
   docker-compose up -d redis
   ```

2. **Web app only**:
   ```bash
   rackup config.ru -p 9999
   ```

3. **Sidekiq only**:
   ```bash
   bundle exec sidekiq -C config/sidekiq.yml -r ./Rakefile
   ```

### Debugging

- Use `pry` gem for debugging (already included)
- Check Sidekiq logs via the Web UI
- Monitor Redis: `redis-cli monitor`

## 📁 Project Structure

```
solucao/
├── config.ru                 # Rack application entry point
├── Rakefile                  # Task definitions
├── Gemfile                   # Ruby dependencies
├── .env                      # Environment variables
├── docker-compose.yml        # Docker services
├── payment_gateway.rb        # Main Sinatra application
├── config/
│   └── sidekiq.yml          # Sidekiq configuration
├── connections/
│   └── redis.rb             # Redis connection setup
├── jobs/
│   └── process_payment_job.rb # Background payment processing
└── lib/
    └── default_connector.rb  # External service connector
```

## 🔍 Monitoring & Observability

### Sidekiq Web UI
- **URL**: http://localhost:9999/sidekiq
- **Features**: Job monitoring, queue management, performance metrics

### Health Checks
The service includes health checking for external payment processors with Redis caching (5-second TTL).

### Logging
- Payment processing events are logged to `log.txt`
- Sidekiq provides detailed job execution logs

## 🐳 Docker Support

The project includes Docker Compose configuration for Redis:

```bash
# Start Redis
docker-compose up -d redis

# Stop all services
docker-compose down
```

## 🚦 Production Considerations

1. **Security**: Add authentication to Sidekiq Web UI
2. **Monitoring**: Integrate with monitoring solutions (Prometheus, etc.)
3. **Persistence**: Configure Redis persistence
4. **Scaling**: Use multiple Sidekiq processes for high throughput
5. **Error Handling**: Implement proper error handling and alerting

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is part of the Rinha 2025 challenge.

---

**Need help?** Check the Sidekiq Web UI at http://localhost:9999/sidekiq for job monitoring and debugging.
