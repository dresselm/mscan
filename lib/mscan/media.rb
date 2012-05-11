require 'digest/md5'

module Mscan #nodoc
  # Media file wrapper
  class Media
    attr_reader :path,
                :file_name,
                :file_type

    def initialize(file_path)
      @path = file_path
      @file_name = file_path.split('/').last
      @file_type = @file_name.split('.').last
    end

    # Returns a hash representing media file attributes
    def to_params
      {:fingerprint => fingerprint}
    end

    # Returns a unique identifier for the file
    def fingerprint
      Digest::MD5.file(@path)
    end

  end
end