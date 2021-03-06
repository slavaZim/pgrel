$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

if ENV['COVER']
  require 'simplecov'
  SimpleCov.root File.join(File.dirname(__FILE__), '..')
  SimpleCov.start
end

require 'rspec'
require 'pry-byebug'
require 'active_record'
require 'pg'
require 'pgrel'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  username: 'pgrel',
  database: 'pgrel'
)
connection = ActiveRecord::Base.connection

unless connection.extension_enabled?('hstore')
  connection.enable_extension 'hstore'
  connection.commit_db_transaction
end

connection.reconnect!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
end
