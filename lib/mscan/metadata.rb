require 'yajl'

module Mscan #nodoc
  # Utility wrapper for writing and reading mscan metadata files
  class Metadata
    # Metadata file name
    FILE_NAME = 'meta.mscan'

    class Error < RuntimeError; end #nodoc
    # The error raised when the file path is invalid
    class InvalidPathError < Error; end

    # TODO add attr_accessor for each of the metada
    #      fields that we want to store
    #      #write should be changed to take a path and a Metadata object

    # Write metadata to the given path
    #
    # @param [String] the full path to the metadata file
    # @param [Object] the content to be written to the file
    def self.write(path, content={})
      # Ensure that the directory exists
      FileUtils.mkdir_p(path)
      File.open(meta_data_file(path), 'w+') do |f|
        f.puts(::Yajl::Encoder.encode(content))
      end
    end

    # Read the metadata for the given path
    #
    # @param  [String] the full path to the metadata file
    # @return [Object] the parsed metadata content
    def self.read(path)
      meta_data_file_path = meta_data_file(path)

      unless File.exists?(meta_data_file_path)
        raise InvalidPathError, "#{meta_data_file_path} is not a valid file path"
      end

      File.open(meta_data_file_path, 'r') do |f|
        ::Yajl::Parser.parse(f)
      end
    end

    # Appends the metadata file name to the supplied path
    #
    # @param [String] the full path to the metadata file
    # @return [String] the full path to the metadata file including the file name
    def self.meta_data_file(path)
      "#{path}/#{FILE_NAME}"
    end
    private_class_method :meta_data_file
  end
end