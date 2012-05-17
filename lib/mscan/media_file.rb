require 'digest/md5'

module Mscan #nodoc
  # MediaFile file wrapper
  class MediaFile

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
    # @return [Mscan::MediaFileType] the media type
    def type
      Mscan::MediaFileType.for_file_name(name)
    end

    # Returns the file size in bytes
    #
    # @return [Integer] the file size
    def size
      @file.size
    end

    # Returns the time the file was last modified
    #
    # @return [Time] the modification time
    def modified_at
      @file.mtime
    end

    # Returns the time the file was created
    #
    # @return [Time] the creation time
    def created_at
      @file.ctime
    end

    # Returns a hash representing various media file attributes
    #
    # @return [Hash] a hash representing media file attributes
    def to_params(*params)
      base_params = {
        :created_at  => created_at,
        :modified_at => modified_at,
        :size        => size
      }

      optional_params = {}
      params.each do |param|
        optional_params[param.to_sym] = send(param)
      end

      base_params.merge(optional_params)
    end

    # Returns a unique identifier, or fingerprint, for the file
    # The identifier will be different if the file's contents change.
    #
    # @return [Digest::MD5] the unique fingerprint
    def fingerprint
      Digest::MD5.file(path)
    end

    # Returns true if the path represents a file and
    # a valid {MediaFileType}
    #
    # @param [String] file_path
    # @return [Boolean] returns true if the path represents a valid media file
    def self.valid?(file_path)
      File.file?(file_path) && MediaFileType.valid?(file_path)
    end

  end
end