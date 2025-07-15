require 'sequel'
require 'connection_pool'

# Create direct database connection for Sequel::Model
DATABASE = Sequel.connect(ENV.fetch('CONNECTION_URL'))
