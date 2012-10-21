module Mscan # :nodoc:
  # Analyzes metadata files and prepares information for reporting
  class Analyzer
    include Store

    # List of all available analyzers
    ANALYZERS = [:redundancy]

    # Analyzes the most recent composite scan data via one or more Analyzers and saves
    # the analysis to a timestamped file that can be consumed by a Reporter.
    def self.analyze
      Logger.measure('Analyzing') do
        raw_meta_data = load_most_recent("#{COMPOSITE_SCAN_OUTPUT_DIR}/#{COMPOSITE_SCAN_FILE_NAME}")

        # Pass raw data through analysis
        ANALYZERS.each do |analyzer|
          analyzer_class = analyzer_class_from_symbol(analyzer)
          save_analysis(analyzer_class.analyze(raw_meta_data))
        end
      end
    end

    # Calculates the total size of all data files.
    #
    # @param [Array] data_files
    # @return [Integer] the total size of the data.
    def self.total_size(data_files)
      return 0 if data_files.nil? || data_files.empty?

      data_files.inject(0) {|total_size, data_file| total_size + data_file['size']}
    end

    # Calculates the total number of data files.
    #
    # @param [Array] data_files
    # @return [Integer] the total number of files represented in the array.
    def self.file_count(data_files)
      return 0 if data_files.nil?

      data_files.size
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
      return if analyzer.nil?

      save("#{ANALYSIS_OUTPUT_DIR}/#{timestamp(ANALYSIS_FILE_NAME)}", analyzer.to_params)
    end
    private_class_method :save_analysis

  end
end