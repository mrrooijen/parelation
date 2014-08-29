ROOT_PATH = File.expand_path("../../..", __FILE__)
SPEC_PATH = File.join(ROOT_PATH, "spec")
TMP_PATH = File.join(ROOT_PATH, "tmp")
DB_PATH = File.join(TMP_PATH, "parelation.db")
LOG_PATH = File.join(TMP_PATH, "parelation.log")
FileUtils.mkdir_p(TMP_PATH)

require "pry"
require "logger"
require "sqlite3"
require "active_record"
require "fileutils"
require "#{SPEC_PATH}/support/db"
