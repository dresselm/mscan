module Mscan
  module Analysis
    class Redundancy

      attr_reader :raw_data, :transformed_data

      def initialize(raw_meta_data)
        @raw_data = raw_meta_data
        @transformed_data = transform
      end

      def transform
        fingerprint_hash = {}
        raw_data.each do |k, v|
          fingerprint = v.delete('fingerprint')
          if obj = fingerprint_hash[fingerprint]
            obj[:media] << v.merge(:path => k)
          else
            fingerprint_hash[fingerprint] = {:media => [v.merge(:path => k)]}
          end
        end
        fingerprint_hash
      end

      # TODO analyze needs to parse the transformed data for interesting tidbits
      def analyze
        # duplicates sorted by base path
        ## :duplicates => []
        # uniques sorted by base path
        ## :uniques => []
        #

        save
      end

      # TODO some of these (top 3) should be in the base class
      def to_params
        {
          :dirs => Mscan::Settings.scan_directories,
          :size => total_size,
          :num_files => total_number_files,
          :unique_size => total_unique_size,
          :num_unique_files => total_number_unique_files,

          :unique_media => transformed_data
        }
      end

      # Put this in the base class
      def save
        Mscan::Analyzer.save_analysis(self)
      end

      def total_size
        Mscan::Analyzer.total_size(raw_data.values)
      end

      def total_number_files
        Mscan::Analyzer.total_number_files(raw_data)
      end

      # TODO Fix inconsistencies when accessing symbols vs strings vs instance vars
      def total_unique_size
        media_files = transformed_data.values.map {|v| v[:media]}
        # All the media files pointing to the same fingerprint are identical, so just pick the first
        unique_media_files = media_files.map(&:first)
        Mscan::Analyzer.total_size(unique_media_files)
      end

      def total_number_unique_files
        Mscan::Analyzer.total_number_files(transformed_data)
      end
    end
  end
end