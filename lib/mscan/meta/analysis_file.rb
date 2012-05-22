module Mscan::Meta

  # TODO upon more thought I think this should be a dummy class and take an analyzer object populated with stats
  class AnalysisFile
    include Mscan::MetaFile

    ANALYSIS_OUTPUT_DIR = 'analysis'

    def initialize(analyzer)
      @analyzer = analyzer
    end

    def to_params
      {
        :dirs => Mscan::Settings.scan_directories,
        :size => total_size,
        :num_files => total_number_files,
        :unique_size => total_unique_size,
        :num_unique_files => total_number_unique_files,
        :unique_media => @analyzer.transformed_meta_data
      }
    end

    def total_size
      Mscan::Analyzer.total_size(@analyzer.raw_meta_data.values)
    end

    def total_number_files
      Mscan::Analyzer.total_number_files(@analyzer.raw_meta_data)
    end

    # TODO Fix inconsistencies when accessing symbols vs strings vs instance vars
    def total_unique_size
      media_files = @analyzer.transformed_meta_data.values.map {|v| v[:media]}
      # All the media files pointing to the same fingerprint are identical, so just pick the first
      unique_media_files = media_files.map(&:first)
      Mscan::Analyzer.total_size(unique_media_files)
    end

    def total_number_unique_files
      Mscan::Analyzer.total_number_files(@analyzer.transformed_meta_data)
    end

    def write
      Mscan::Meta::AnalysisFile.write(ANALYSIS_OUTPUT_DIR, to_params, true)
    end

  end
end