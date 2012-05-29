module Mscan #nodoc
  module Analysis #nodoc
    # Redundancy analysis identifies redundant and non-redundant media files
    # across source and target directories
    class Redundancy

      attr_reader :raw_data, :transformed_data

      def initialize(raw_data, transformed_data)
        @raw_data = raw_data
        @transformed_data = transformed_data
      end

      def self.analyze(raw_data)
        transformed_data = transform(raw_data)
        redundancy_analysis = new(raw_data, transformed_data)
        # duplicates sorted by base path
        ## :duplicates => []
        # uniques sorted by base path
        ## :uniques => []
        #
        redundancy_analysis
      end

      # Transforms a raw meta data hash into a fingerprint-centric
      # lookup for easily identifying redundant files.  If multiple files have
      # the same fingerprint, they are added to the :media array.
      #
      # @param [Hash] raw_data
      # @return [Hash] the transformed data
      def self.transform(raw_data={})
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

      # Returns a params hash with essential data related to the redundancy analysis.
      #
      # @return [Hash] the redundancy analysis params
      def to_params
        {
          # TODO pull these directories from the raw_data hash
          :source_dirs => Mscan::Settings.source_directories,
          :target_dirs => Mscan::Settings.target_directories,

          :size => total_size,
          :num_files => total_number_files,

          :unique_size => total_unique_size,
          :num_unique_files => total_number_unique_files,
          :unique_media => transformed_data
        }
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