require 'configuration'

module Mscan

  Config = Configuration.for('app') do
    log_level ::Logger::INFO

    # mscan output directory
    output_directory   'output'

    # scan directories
    source_directories ['/Volumes/My Book/Matts Computer/C_My Pictures','/Volumes/My Book/Matts Mac 2/Photos','/Volumes/My Book/Matts Mac 2/Pictures','/Volumes/My Book/Suzannes Computer/C_My Pictures','/Volumes/My Book/Suzannes Computer/C_My Pictures','/Volumes/My Book/Suzannes Macbook Air/Pictures Backup']
    target_directories ['/Volumes/Backup 1TB/Photos','/Volumes/Backup 1TB/Video']
    scan_directories   source_directories + target_directories
  end

end