# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mscan/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Dressel"]
  gem.email         = ["matt.dressel@gmail.com"]
  gem.description   = %q{A utility to help manage our growing media collections}
  gem.summary       = %q{This utility supports the ability to identify all unique media files and detect duplicates}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "mscan"
  gem.require_paths = ["lib"]
  gem.version       = Mscan::VERSION

  gem.add_runtime_dependency(%q<yajl-ruby>)
  gem.add_runtime_dependency(%q<active_support>)

  gem.add_development_dependency(%q<simplecov>)
  gem.add_development_dependency(%q<yard>)
end
