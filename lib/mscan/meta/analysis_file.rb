module Mscan::Meta

  # TODO upon more thought I think this should be a dummy class and take an analyzer object populated with stats
  class AnalysisFile
    include Mscan::MetaFile

    ANALYSIS_OUTPUT_DIR = 'analysis'

    attr_reader :raw_meta_data, :transformed_meta_data

    def initialize(raw_meta_data)
      @raw_meta_data = raw_meta_data
      @transformed_meta_data = transform_meta_data
    end

    def total_size
      raw_meta_data.values.inject(0) {|result, element| result + element['size']}
    end

    def total_number_files
      raw_meta_data.keys.size
    end

    # TODO Fix inconsistencies when accessing symbols vs strings vs instance vars
    def total_unique_size
      media_files = transformed_meta_data.values.map {|v| v[:media]}
      # All the media files pointing to the same fingerprint are identical, so just pick the first
      unique_media_files = media_files.map(&:first)
      unique_media_files.inject(0) {|result, element| result + element['size']}
    end

    def total_number_unique_files
      transformed_meta_data.keys.size
    end

    def write
      Mscan::Meta::AnalysisFile.write(ANALYSIS_OUTPUT_DIR, to_params, true)
    end

    def to_params
      {
        :dirs => Mscan::Settings.scan_directories,
        :size => total_size,
        :num_files => total_number_files,
        :unique_size => total_unique_size,
        :num_unique_files => total_number_unique_files,
        :unique_media => transformed_meta_data
      }
    end

    def transform_meta_data
      fingerprint_hash = {}
      @raw_meta_data.each do |k, v|
        fingerprint = v.delete('fingerprint')
        if obj = fingerprint_hash[fingerprint]
          obj[:media] << v.merge(:path => k)
        else
          fingerprint_hash[fingerprint] = {:media => [v.merge(:path => k)]}
        end
      end
      fingerprint_hash
    end
  end
end