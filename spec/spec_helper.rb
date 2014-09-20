$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))
require File.expand_path("../support/env", __FILE__)

require "database_cleaner"
require "simplecov"
SimpleCov.start

require "parelation"

RSpec.configure do |config|
  config.before { DatabaseCleaner.start }
  config.after { DatabaseCleaner.clean }
end
