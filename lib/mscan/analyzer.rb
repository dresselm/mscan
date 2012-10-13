module Mscan # :nodoc:
  # Analyzes metadata files and prepares information for reporting
  class Analyzer
    include Store

    # List of all available analyzers
    ANALYZERS = [:redundancy]

    # Analyzes the most recent composite scan data via one or more Analyzers and saves
    # the analysis to a timestamped file that can be consumed by a Reporter.
    def self.analyze
      Profiler.measure('Analyzing') do
        raw_meta_data = load_most_recent("#{ANALYSIS_OUTPUT_DIR}/#{COMPOSITE_SCAN_FILE_NAME}")

        # Pass raw data through analysis
        ANALYZERS.each do |analyzer|
          analyzer_class = analyzer_class_from_symbol(analyzer)
          save_analysis(analyzer_class.analyze(raw_meta_data))
        end
      end
    end

    # Calculates the total size of all raw data files.
    #
    # @param [Array] raw_data_files
    # @return [Integer] the total size of the raw data.
    def self.total_size(raw_data_files)
      raw_data_files.inject(0) {|total_size, raw_data_file| total_size + raw_data_file['size']}
    end

    # Calculates the total number of files represented in the raw data hash parameter.
    #
    # @param [Hash] raw_data_hash
    # @return [Integer] the total number of files represented in the hash parameter.
    def self.file_count(raw_data_hash)
      raw_data_hash.keys.size
    end

    # Returns the Analyzer associated with the given symbol
    # @param [Symbol] sym
    # @return [Class] analyzer class
    def self.analyzer_class_from_symbol(sym)
      Mscan::Analysis.const_get(sym.to_s.capitalize)
    end
    private_class_method :analyzer_class_from_symbol

    # Saves the {Mscan::Analysis analyzer} to a timestamped file
    #
    # @param [Mscan::Analysis] analyzer
    # @return [String] path to analysis file
    def self.save_analysis(analyzer)
      save("#{ANALYSIS_OUTPUT_DIR}/#{timestamp(ANALYSIS_FILE_NAME)}", analyzer.to_params)
    end
    private_class_method :save_analysis

  end
end