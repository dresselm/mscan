# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mscan/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Dressel"]
  gem.email         = ["matt.dressel@gmail.com"]
  gem.description   = %q{A utility to help manage our growing media collections}
  gem.summary       = %q{This utility helps manage media files by categorizing, detecting duplicates, differences and changes between multiple directories.}
  gem.homepage      = "https://github.com/dresselm/mscan"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "mscan"
  gem.require_paths = ["lib"]
  gem.version       = Mscan::VERSION

  # BEGIN
  # Once I determine what is being used, I need to slim this down
  gem.add_runtime_dependency('actionpack')
  gem.add_runtime_dependency('activesupport')
  # END

  gem.add_runtime_dependency('configuration', '~> 1.3.2')
  gem.add_runtime_dependency('rainbow')
  gem.add_runtime_dependency('yajl-ruby')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('redcarpet','2.1.1')
  gem.add_development_dependency('yard')
end
