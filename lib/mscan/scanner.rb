require 'find'

module Mscan #nodoc
  # Scans directories, instruments media files and stores
  # the instrumentation data in metadata files
  class Scanner

    # Scans the  directory for media files.
    def scan

    end

    def instrument_directory(dir_path)
    end
    private :instrument_directory

    def save_meta_data(path, meta_data)
      Metadata.write(path, meta_data)
    end
    private :save_meta_data

  end
end