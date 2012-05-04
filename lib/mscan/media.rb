require 'digest/md5'

module Mscan
  # TODO move some Find/File functionality that is in scanner to here
  class Media
    attr_reader :path

    def initialize(file_path)
      @path = file_path
    end

    # TODO call this when saving metadata
    def to_params

    end

    def checksum
      Digest::MD5.file(@path)
    end

  end
end