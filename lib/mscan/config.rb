require 'configuration'

module Mscan

  Config = Configuration.for('app') do
    log_level ::Logger::INFO

    # mscan output directory
    output_directory   	'output'

    # scan directories
    source_directories 	[]
    target_directories 	[]
    
    # exclude directories, files and extensions
    exclude_directories []
    exclude_files       []
    exclude_extensions  []
  end

end