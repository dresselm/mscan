module Mscan # :nodoc:
  # Special type of {MediaFile} that represents a container
  # of other {MediaFile media files}
  class ArchiveMediaFile < MediaFile

    # Override to_params to support the complexities
    # of an archive file
    def to_params(*params)

    end
  end
end