lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "parelation/version"

Gem::Specification.new do |spec|
  spec.name = "parelation"
  spec.version = Parelation::VERSION
  spec.authors = ["Michael van Rooijen"]
  spec.email = ["michael@vanrooijen.io"]
  spec.summary = %q{Translates HTTP parameters to ActiveRecord queries.}
  spec.homepage = "http://mrrooijen.github.io/store_schema/"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 5.0.0", "< 6.1.0"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 13.0.0"
  spec.add_development_dependency "rspec", "~> 3.9.0"
  spec.add_development_dependency "database_cleaner", "~> 1.8.0"
  spec.add_development_dependency "pry", "~> 0.12.0"
  spec.add_development_dependency "simplecov", "~> 0.18.0"
  spec.add_development_dependency "yard", "~> 0.9.0"
end
