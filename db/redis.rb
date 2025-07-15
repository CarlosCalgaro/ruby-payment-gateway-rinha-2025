REDIS ||= ConnectionPool::Wrapper.new do
  Redis.new(url: ENV["REDIS_URL"])
end