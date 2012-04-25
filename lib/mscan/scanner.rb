module Mscan #nodoc

  class Scanner

    def initialize
      @scan_dir = Config.new.attribute('scanner','default_scan_directory')
      puts "Scanning the #{@scan_dir} directory...\n"
    end

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
        Find.find(@scan_dir) do |path|
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