require 'yajl'
require 'fileutils'
require 'active_support/inflector'

module Mscan #nodoc
  # Utility wrapper for reading and writing meta files
  module Store

    ANALYSIS_OUTPUT_DIR      = 'analysis'
    META_FILE_NAME           = 'meta.mscan'
    COMPOSITE_SCAN_FILE_NAME = 'scan.mscan'
    ANALYSIS_FILE_NAME       = 'analysis.mscan'

    def self.included(base)
      base.extend(ClassMethods)
    end

    class Error < RuntimeError; end #nodoc
    # The error raised when the file path is invalid
    class InvalidPathError < Error; end

    module ClassMethods
      # Writes {Mscan::MediaDir} metadata to the given path
      #
      # @param [String] the full path to the metadata file
      # @param [MediaDir] the {MediaDir} whose contents will be written to the file
      def save(full_path, content={})
        # Ensure that the directory exists
        FileUtils.mkdir_p(File.dirname(full_path))
        File.open(full_path, 'w+') do |f|
          f.puts(Yajl::Encoder.encode(content))
        end
        full_path
      end

      # Read the metadata for the given path
      #
      # @param  [String] the full path to the metadata file
      # @return [Object] the parsed metadata content
      def load(full_path)
        parse(full_path)
      end

      def load_most_recent(full_path)
        file_name = File.basename(full_path)
        dir_name = File.dirname(full_path)
        # TODO improve this once the timestamps have been ironed out
        most_recent_path = Dir.glob("#{dir_name}/*_#{file_name}").last || Dir.glob("#{dir_name}/*#{file_name}").last
        parse(most_recent_path)
      end

      def timestamp(file_name)
        "#{Time.now.to_i}_#{file_name}"
      end

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