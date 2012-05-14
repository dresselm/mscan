require 'digest/md5'

module Mscan #nodoc
  # Media file wrapper
  class Media

    def initialize(file_path)
      @file = File.new(file_path)
    end

    # Returns the relative file path
    #
    # @return [String] the relative file path
    def path
      @path ||= @file.path
    end

    # Returns the absolute file path
    #
    # @return [String] the absolute file path
    def absolute_path
      File.absolute_path(path)
    end

    # Returns the file name
    #
    # @return [String] the file name
    def name
      File.basename(path)
    end

    # Returns the file type
    #
    # @return [Mscan::MediaType] the media type
    def type
      Mscan::MediaType.for_file_name(name)
    end

    def size
      @file.size
    end

    def modified_at
      @file.mtime
    end

    def created_at
      @file.ctime
    end

    # Returns a hash representing media file attributes
    #
    # @return [Hash] a hash representing media file attributes
    def to_params
      {
        :fingerprint => fingerprint,
        :modified_at => modified_at,
        :size        => size
      }
    end

    # Returns a unique identifier, or fingerprint, for the file
    # The identifier will be different if the file's contents change.
    #
    # @return [Digest::MD5] the unique fingerprint
    def fingerprint
      Digest::MD5.file(path)
    end

  end
end