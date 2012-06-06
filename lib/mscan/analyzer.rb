module Mscan #nodoc
  # Analyzes metadata files and prepares information for reporting
  class Analyzer
    include Store

    # Analyzes the most recent composite scan data via one or more Analyzers and saves
    # the analysis to a timestamped file that can be consumed by a Reporter.
    def self.analyze
      Profiler.measure('Analyzing') do
        raw_meta_data = load_most_recent("#{ANALYSIS_OUTPUT_DIR}/#{COMPOSITE_SCAN_FILE_NAME}")

        # Pass raw data through analysis
        save_analysis(Mscan::Analysis::Redundancy.analyze(raw_meta_data))
      end
    end

    # Saves the {Mscan::Analysis analyzer} to a timestamped file
    #
    # @param [Mscan::Analysis] analyzer
    # @return [String] path to analysis file
    def self.save_analysis(analyzer)
      save("#{ANALYSIS_OUTPUT_DIR}/#{timestamp(ANALYSIS_FILE_NAME)}", analyzer.to_params)
    end

    # Calculates the total size of all {Mscan::MediaFile media file} parameters.
    #
    # @param [Array] media_files
    # @return [Integer] the total size of {Mscan::MediaFile media file} parameters.
    def self.total_size(media_files)
      media_files.inject(0) {|total_size, media_file| total_size + media_file['size']}
    end

    # Calculates the total number of files represented in the meta_data hash parameter.
    #
    # @param [Hash] meta_data_hash
    # @return [Integer] the total number of files represented in the hash parameter.
    def self.total_number_files(meta_data_hash)
      meta_data_hash.keys.size
    end

  end
end