module Mscan #nodoc
  # Analyzes metadata files and prepares information for reporting
  class Analyzer
    include Store

    def self.analyze
      Profiler.measure('Analyzing') do
        raw_meta_data = load_most_recent("#{ANALYSIS_OUTPUT_DIR}/#{AGGREGATE_SCAN_FILE_NAME}")

        # Pass raw data through analysis
        Mscan::Analysis::Redundancy.new(raw_meta_data).analyze
      end
    end

    def self.save_analysis(analyzer)
      save("#{ANALYSIS_OUTPUT_DIR}/#{timestamp(ANALYSIS_FILE_NAME)}", analyzer.to_params)
    end

    def self.total_size(media_files)
      media_files.inject(0) {|total_size, media_file| total_size + media_file['size']}
    end

    def self.total_number_files(meta_data_hash)
      meta_data_hash.keys.size
    end

  end
end