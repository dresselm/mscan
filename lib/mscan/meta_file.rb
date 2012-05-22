require 'yajl'
require 'fileutils'
require 'active_support/inflector'

module Mscan #nodoc
  # Utility wrapper for reading and writing meta files
  module MetaFile

    FILE_EXTENSION = 'mscan'

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
      def write(path, content={}, timestamp=false)
        # Ensure that the directory exists
        FileUtils.mkdir_p(path)
        meta_file_path = path_to_meta_file(path, timestamp)
        File.open(meta_file_path, 'w+') do |f|
          f.puts(Yajl::Encoder.encode(content))
        end
        meta_file_path
      end

      # Read the metadata for the given path
      #
      # @param  [String] the full path to the metadata file
      # @return [Object] the parsed metadata content
      def read(path)
        meta_file_path = path_to_meta_file(path)
        parse(meta_file_path)
      end

      def read_most_recent(glob_path)
        # meta_file_path = Dir.glob('analysis/*scan.mscan').last
        full_glob_path = "#{glob_path}/*#{class_to_file_name}.#{FILE_EXTENSION}"
        meta_file_path = Dir.glob(full_glob_path).last
        parse(meta_file_path)
      end

      # Appends the metadata file name to the supplied path
      #
      # @param [String] the full path to the metadata file
      # @return [String] the full path to the metadata file including the file name
      def path_to_meta_file(path, timestamp=false)
        file_name = class_to_file_name
        file_name = "#{Time.now.to_i}_#{file_name}" if timestamp
        "#{path}/#{file_name}.#{FILE_EXTENSION}"
      end

      def class_to_file_name
        self.name.demodulize.gsub(/File/,'').underscore
      end

      def parse(meta_file_path)
        unless File.exists?(meta_file_path)
          raise InvalidPathError, "#{meta_file_path} is not a valid file path"
        end

        File.open(meta_file_path, 'r') do |f|
          Yajl::Parser.parse(f)
        end
      end
      private :parse
    end

  end
end