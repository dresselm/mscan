module Mscan #nodoc
  # Scans directories, instruments media files and stores
  # the instrumentation data in metadata files.  Once initial scanning
  # completes, a composite file is generated for consumption.
  class Scanner
    include Store

    # Scans all configured scan directories searching for valid {MediaFile files}.
    # Instruments the files and captures informative data.  Saves the data to
    # files in the each originating directory and produces a composite scan file
    # upon completion.
    #
    # @return [String] the path to the composite scan file
    def self.scan
      Profiler.measure('Scanning') do
        composite_scan_data = {}
        MediaDir.find_all_media_dirs.each do |media_dir|
          media_dir_path = media_dir.path
          media_dir_data = media_dir.to_params(:fingerprint)
          # Save the scan meta file in the originating directory
          save("#{media_dir_path}/#{META_FILE_NAME}", media_dir_data)
          # Add the scan meta data to the composite
          composite_scan_data.merge!(prepend_path_to_keys(media_dir_path, media_dir_data))
        end
        # Save the composite scan data to the analysis directory
        save_composite_scan_data(composite_scan_data)
      end
    end

    # Saves the composite scan data to a timestamped file
    #
    # @param [Hash] composite_scan_data
    # @return [String] the full path to the composite scan file
    def self.save_composite_scan_data(composite_scan_data)
      full_path = "#{ANALYSIS_OUTPUT_DIR}/#{timestamp(COMPOSITE_SCAN_FILE_NAME)}"
      save(full_path, composite_scan_data)
    end
    private_class_method :save_composite_scan_data

    # Prepend the full {MediaDir directory} path to each filename key.
    #
    # @param [String] directory_path the full {MediaDir directory} path
    # @param [Object] directory_data data for all {MediaFile files} within the {MediaDir directory}
    # @return [Object]
    def self.prepend_path_to_keys(path, data)
      prepended_keys = data.map do |k, v|
        ["#{path}/#{k}", v]
      end
      Hash[prepended_keys]
    end
    private_class_method :prepend_path_to_keys

  end
end