module Mscan #nodoc
  # Utility wrapper for writing and reading mscan metadata files
  class Metadata
    # Metadata file name
    FILE_NAME = 'meta.mscan'

    # Write metadata to the given path
    #
    # @param [String] the full path to the metadata file
    # @param [Object] the content to be written to the file
    def self.write(path, content)
      File.open(meta_data_file(path), 'w+') do |f|
        f.puts(Yajl::Encoder.encode(content))
      end
    end

    # Read the metadata for the given path
    #
    # @param  [String] the full path to the metadata file
    # @return [Object] the parsed metadata content
    def self.read(path)
      File.open(meta_data_file(path), 'r') do |f|
        Yajl::Parser.parse(f)
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