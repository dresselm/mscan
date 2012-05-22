module Mscan #nodoc
  # Scans directories, instruments media files and stores
  # the instrumentation data in metadata files
  class Scanner

    # Scans all configured scan directories searching for valid {MediaFile files}.
    # Instruments the files and captures informative data.  Saves the data to
    # files in the each originating directory and produces an aggregate scan file
    # upon completion.
    #
    # @return [String] the path to the aggregate scan file
    def scan
      Profiler.measure('Scanning') do
        aggregate_scan_data = {}
        MediaDir.find_all_media_dirs.each do |media_dir|
          media_dir_path = media_dir.path
          media_dir_data = media_dir.to_params(:fingerprint)
          # Save the scan meta file in the originating directory
          Mscan::Meta::ScanFile.write(media_dir_path, media_dir_data)
          # Add the scan meta data to the aggregate
          aggregate_scan_data.merge!(prepend_path_to_keys(media_dir_path, media_dir_data))
        end
        # Save the aggregate scan data to the analysis directory
        Mscan::Meta::ScanFile.write_aggregate(aggregate_scan_data)
      end
    end

    # Prepend the full {MediaDir directory} path to each filename key.
    #
    # @param [String] directory_path the full {MediaDir directory} path
    # @param [Object] directory_data data for all {MediaFile files} within the {MediaDir directory}
    # @return [Object]
    def prepend_path_to_keys(path, data)
      prepended_keys = data.map do |k, v|
        ["#{path}/#{k}", v]
      end
      Hash[prepended_keys]
    end
    private :prepend_path_to_keys

  end
end