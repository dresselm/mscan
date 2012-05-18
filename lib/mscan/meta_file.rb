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
      def write(path, content={})
        # Ensure that the directory exists
        FileUtils.mkdir_p(path)
        File.open(path_to_meta_file(path), 'w+') do |f|
          f.puts(Yajl::Encoder.encode(content))
        end
      end

      # Read the metadata for the given path
      #
      # @param  [String] the full path to the metadata file
      # @return [Object] the parsed metadata content
      def read(path)
        meta_file_path = path_to_meta_file(path)

        unless File.exists?(meta_file_path)
          raise InvalidPathError, "#{meta_file_path} is not a valid file path"
        end

        File.open(meta_file_path, 'r') do |f|
          Yajl::Parser.parse(f)
        end
      end

      # Appends the metadata file name to the supplied path
      #
      # @param [String] the full path to the metadata file
      # @return [String] the full path to the metadata file including the file name
      def path_to_meta_file(path)
        file_name = self.name.demodulize.gsub(/File/,'').underscore
        "#{path}/#{file_name}.#{FILE_EXTENSION}"
      end
    end

  end
end