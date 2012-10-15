require 'configuration'

module Mscan

  Config = Configuration.for('app') do
    verbose true
    source_directories ['/Users/matt/tmp/scan']
    target_directories []
    scan_directories   source_directories + target_directories
  end

end