require "pry"
require "active_record"

ROOT_PATH = File.expand_path("../../..", __FILE__)
SPEC_PATH = File.join(ROOT_PATH, "spec")

require "#{SPEC_PATH}/support/db"
