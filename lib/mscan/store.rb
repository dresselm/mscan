require 'yajl'
require 'fileutils'
require 'active_support/inflector'

module Mscan # :nodoc:
  # Utility wrapper for reading and writing meta files
  module Store

    # The extension for all files generated by mscan
    EXTENSION                = 'mscan'
    # The root directory for analysis files
    ANALYSIS_OUTPUT_DIR      = 'analysis'
    # The name of the file that mscan generates for each originating directory
    META_FILE_NAME           = "meta.#{EXTENSION}"
    # The name of the local composite file that mscan generates
    COMPOSITE_SCAN_FILE_NAME = "scan.#{EXTENSION}"
    # The name of the local analysis file that mscan generates
    ANALYSIS_FILE_NAME       = "analysis.#{EXTENSION}"

    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
    end

    class Error < RuntimeError; end # :nodoc:
    # The error raised when the file path is invalid
    class InvalidPathError < Error; end

    module ClassMethods # :nodoc:
      # Writes {Mscan::MediaDir} metadata to the given path
      #
      # @param full_path [String] the full path to the metadata file
      # @param content [Mscan::MediaDir] the {MediaDir} whose contents will be written to the file
      # @return [String] the full path
      def save(full_path, content={})
        # Ensure that the directory exists
        FileUtils.mkdir_p(File.dirname(full_path))
        File.open(full_path, 'w+') do |f|
          f.puts(Yajl::Encoder.encode(content))
        end
        full_path
      end

      # Load the metadata for the given path.
      #
      # @param  [String] full_path
      # @return [Object] the parsed metadata content
      def load(full_path)
        parse(full_path)
      end

      # Load the most recent metadata for the given path.
      #
      # @param  [String] full_path
      # @return [Object] the parsed metadata content
      def load_most_recent(full_path)
        file_name = File.basename(full_path)
        dir_name = File.dirname(full_path)

        most_recent_path = Dir.glob("#{dir_name}/*_#{file_name}").last || Dir.glob("#{dir_name}/*#{file_name}").last

        parse(most_recent_path)
      end

      # Prepend a timestamp to the file_name.
      #
      # @param [String] file_name
      # @return [String] the timestamped file name
      def timestamp(file_name)
        "#{Time.now.to_i}_#{file_name}"
      end
      private :timestamp

      # Parse the json file represented by full_path.
      #
      # @param [String] full_path
      # @return [Object] the parsed json metadata object
      def parse(full_path)
        if full_path.nil? || !File.exists?(full_path)
          raise InvalidPathError, "#{full_path} is not a valid file path"
        end

        File.open(full_path, 'r') do |f|
          Yajl::Parser.parse(f)
        end
      end
      private :parse
    end

  end
end