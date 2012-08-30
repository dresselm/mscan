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

      # Transforms and analyzes raw meta data to determine
      # whether there are any redundant files
      #
      # @param [Hash] raw_data
      # @return [Redundancy] the {Redundancy redundancy analysis}
      def self.analyze(raw_data)
        transformed_data    = transform(raw_data)
        redundancy_analysis = new(raw_data, transformed_data)

        # TODO Organize duplicates/unique by their source/target root dirs

        redundancy_analysis
      end

      # Transforms a raw meta data hash into a fingerprint-centric
      # data structure.  If multiple files have the same fingerprint,
      # they are added to the 'media' array.  'count' is a running count
      # of duplicates.  'size' represents the size of each media file.
      #
      # Example:
      # { 123456789 => { 'count' => 1, 'size' => 123456, 'media' => [{'modified_at' => 1234, 'path' => 'blah/blah.png'}] } }
      #
      # @param [Hash] data_data
      # @return [Hash] the transformed data
      def self.transform(data={})
        fingerprint_hash = {}
        return fingerprint_hash if data.nil?

        data.each do |key, value|
          data_value = value.dup
          fingerprint = data_value.delete('fingerprint')
          file_size   = data_value.delete('size')
          if fingerprint_hash[fingerprint]
            fingerprint_hash[fingerprint]['count'] += 1
          else
            fingerprint_hash[fingerprint] = {'count' => 1, 'size' => file_size, 'media' => []}
          end
          fingerprint_hash[fingerprint]['media'] << data_value.merge('path' => key)
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
          :num_files => file_count,

          :unique_size => total_unique_size,
          :num_unique_files => unique_file_count,
          :num_duplicate_files => duplicate_file_count,
          :unique_media => transformed_data
        }
      end

      # Returns the total size of all scanned files in bytes
      #
      # @return [Integer] the total file size
      def total_size
        Mscan::Analyzer.total_size(raw_data.values)
      end

      # Returns the total number of scanned files
      #
      # @return [Integer] the total number of files
      def file_count
        Mscan::Analyzer.file_count(raw_data)
      end

      # Returns the total size of all unique scanned files
      #
      # @return [Integer] the total size of unique files
      # TODO Fix inconsistencies when accessing symbols vs strings vs instance vars
      def total_unique_size
        Mscan::Analyzer.total_size(transformed_data.values)
      end

      # Returns the total number of unique scanned files
      #
      # @return [Integer] the total number of unique files
      def unique_file_count
        Mscan::Analyzer.file_count(transformed_data)
      end

      # Returns the total number of duplicate files
      #
      # @return [Integer] the total number of duplicate files
      def duplicate_file_count
        file_count - unique_file_count
      end
    end
  end
end