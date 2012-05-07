module Mscan #nodoc
  # Scans directories, instruments media files and stores
  # the instrumentation data in metadata files
  class Scanner

    def initialize
      @scan_dirs = Mscan::Settings.scan_directories
      puts "Scanning the #{@scan_dirs.join(', ')} directories...\n"
    end

    # Scans directories and instruments valid media files
    def scan
      Profiler.measure('scan') do
        find_directories_to_instrument.each do |dir_path|
          instrument_directory(dir_path)
        end
      end
    end

    def find_directories_to_instrument
      directories = []
      Profiler.measure('find_directories') do
        Find.find(@scan_dirs) do |path|
          # Paths are relative to the working directory
          if File.directory?(path)
            Find.prune if File.basename(path)[0] == ?.

            directories << path
          end
        end
      end

      directories
    end
    private :find_directories_to_instrument

    def instrument_directory(dir_path)
      Profiler.measure("instrument #{dir_path}") do
        # TODO
      end
    end
    private :instrument_directory

    def save_meta_data(path, meta_data)
      File.open(meta_data_file(path), 'w+') do |f|
        f.puts(Yajl::Encoder.encode(meta_data))
      end
    end
    private :save_meta_data

  end
end