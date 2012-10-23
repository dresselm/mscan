module Mscan # :nodoc:
  module Analysis # :nodoc:
    # Redundancy analysis identifies redundant and non-redundant media files
    # across source and target directories
    class Redundancy

      attr_reader :raw_data, :transformed_data

      def initialize(raw_data, transformed_data)
        @raw_data         = raw_data
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
      # { 123456789 => { :count => 1,
      #                  :size => 123456,
      #                  :media => [ { :modified_at => 1234, :path => 'blah/blah.png' } ]
      #                } }
      #
      # @param [Hash] data
      # @return [Hash] the transformed data
      def self.transform(data={})
        fingerprint_hash = {}
        return fingerprint_hash if data.nil?

        data.each_pair do |path, path_meta_data|
          media_files = path_meta_data['media_files']
          media_files.each do |media_file|
            fingerprint = media_file.delete('fingerprint')
            if fingerprint_hash[fingerprint]
              fingerprint_hash[fingerprint]['count'] += 1
            else
              file_size = media_file['size']
              fingerprint_hash[fingerprint] = {'count' => 1, 'size' => file_size, 'media_files' => []}
            end
            media_file['path'] = File.join(path, media_file.delete('name'))
            fingerprint_hash[fingerprint]['media_files'] << media_file
          end
        end
        fingerprint_hash
      end

      # @return [Array] the raw data values
      def raw_data_values
        return [] if raw_data.nil?

        @raw_data_values ||= @raw_data.values.map { |rdv| rdv['media_files'] }.flatten
      end

      # @return [Array] the transformed data values
      def transformed_data_values
        return [] if transformed_data.nil?

        @transformed_data_values ||= @transformed_data.values
      end

      # Returns the total size of all scanned files in bytes
      #
      # @return [Integer] the total file size
      def total_size
        Mscan::Analyzer.total_size(raw_data_values)
      end

      # Returns the total number of scanned files
      #
      # @return [Integer] the total number of files
      def file_count
        Mscan::Analyzer.file_count(raw_data_values)
      end

      # Returns the total size of all unique scanned files
      #
      # @return [Integer] the total size of unique files
      # TODO Fix inconsistencies when accessing symbols vs strings vs instance vars
      def total_unique_size
        Mscan::Analyzer.total_size(transformed_data_values)
      end

      # Returns the total number of unique scanned files
      #
      # @return [Integer] the total number of unique files
      def unique_file_count
        Mscan::Analyzer.file_count(transformed_data_values)
      end

      # Returns the total number of duplicate files
      #
      # @return [Integer] the total number of duplicate files
      def duplicate_file_count
        file_count - unique_file_count
      end

      # Returns a params hash with essential data related to the redundancy analysis.
      #
      # @return [Hash] the redundancy analysis params
      def to_params
        {
          # TODO pull these directories from the raw_data hash
          :source_dirs         => Mscan::Config.source_directories,
          :target_dirs         => Mscan::Config.target_directories,

          :size                => total_size,
          :num_files           => file_count,

          :unique_size         => total_unique_size,
          :num_unique_files    => unique_file_count,
          :num_duplicate_files => duplicate_file_count,
          :unique_media        => transformed_data
        }
      end

    end
  end
end