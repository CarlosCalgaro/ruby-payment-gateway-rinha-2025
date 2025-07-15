require 'sinatra/custom_logger'
require 'logger'

LOGGER = Logger.new(File.open("#{File.dirname(__FILE__)}/../log/#{ENV['RACK_ENV'] || 'development'}.log", 'a'))
LOGGER.level = Logger::DEBUG if ENV['RACK_ENV'] == 'development'