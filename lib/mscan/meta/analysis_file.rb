module Mscan::Meta
  class AnalysisFile
    include Mscan::MetaFile

    ANALYSIS_OUTPUT_DIR = 'analysis'

    attr_reader :raw_analysis

    def initialize(raw_analysis)
      @raw_analysis = raw_analysis
    end

    def total_size
      10
    end

    def total_number_files
      10
    end

    def write
      Mscan::Meta::AnalysisFile.write(ANALYSIS_OUTPUT_DIR, to_params, true)
    end

    def to_params
      {
        :dirs => Mscan::Settings.scan_directories,
        :size => total_size,
        :num_files => total_number_files,
        :unique_media => raw_analysis
      }
    end

  end
end