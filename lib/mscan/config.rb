require 'configuration'

module Mscan

  Config = Configuration.for('app') do
    log_level ::Logger::INFO

    # mscan output directory
    output_directory   'output'

    # scan directories
    source_directories ['/tmp/scan']
    target_directories []
    scan_directories   source_directories + target_directories
  end

end