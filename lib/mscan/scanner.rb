require 'find'

module Mscan #nodoc
  # Scans directories, instruments media files and stores
  # the instrumentation data in metadata files
  class Scanner

    # Scans directories and instruments valid media files
    def scan
      find_directories_to_instrument.each do |dir_path|
        instrument_directory(dir_path)
      end
    end

    # TODO shouldn't be here in scanner - monkeypatch Dir?
    # Returns a list of all directories under a given path
    #
    # @param [String] the root path
    # @return [Array] the list of sub
    def self.subdirectories(root_path)
      directories = []
      Find.find(root_path) do |path|
        # Paths are relative to the working directory
        if File.directory?(path)
          # Find.prune if File.basename(path)[0] == ?.
          directories << path
        end

      end
      directories
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