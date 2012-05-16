require 'zip/zip'
require 'zip/zipfilesystem'

module Mscan
  class ArchiveMedium < Medium

    # Override to_params to support the complexities
    # of an archive file
    def to_params(*params)
      # no-op
    end

    # Returns all {Media} files contained within the
    # archive
    #
    # @return [Array] all {Media} found in the archive
    def media
      inner_media = []
      zf = Zip::ZipFile.new(path)
      zf.each_entry do |entry|
        # entry.extract
        puts entry

        # TODO figure out how to work with stream IO

        # next unless Medium.valid?(entity_path)
        # inner_media << Medium.new(entity_path)
      end
      inner_media
    end

  end
end