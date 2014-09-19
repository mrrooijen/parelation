lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "parelation/version"

Gem::Specification.new do |spec|
  spec.name = "parelation"
  spec.version = Parelation::VERSION
  spec.authors = ["Michael van Rooijen"]
  spec.email = ["michael@vanrooijen.io"]
  spec.summary = %q{Translates HTTP parameters to ActiveRecord queries.}
  spec.homepage = "http://meskyanichi.github.io/store_schema/"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 4.1.0"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"
end
