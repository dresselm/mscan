require 'rubygems'

require 'simplecov'
require 'timecop'
require 'bundler/setup'

require 'configuration'
require 'mscan'

Configuration.for('app') do
  verbose false
  source_directories [Dir.pwd + '/spec/media/source']
  target_directories [Dir.pwd + '/spec/media/target']
  scan_directories source_directories + target_directories
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end