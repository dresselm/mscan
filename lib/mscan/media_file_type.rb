module Mscan #nodoc

  module MediaFileType
    extend self

    class MediaFileTypeError < RuntimeError; end #nodoc
    class NoExtensionError < MediaFileTypeError; end
    class UnknownTypeError < MediaFileTypeError; end

    # PHOTO FORMATS
    PNG  = 'png'
    JPEG = 'jpeg'
    JPG  = 'jpg'
    TIFF = 'tiff'

    # VIDEO FORMATS
    MOV  = 'mov'
    MP4  = 'mp4'
    AVI  = 'avi'
    WMV  = 'wmv'
    FLV  = 'flv'

    # AUDIO FORMATS
    MP3  = 'mp3'

    # ARCHIVE FORMATS
    ZIP  = 'zip'
    TAR  = 'tar'
    GZIP = 'gz'

    # All supported media types
    #
    # @return [Array] all supported media types
    def all
      ([] << photo << video << audio << archive).flatten
    end

    # All supported photo types
    #
    # @return [Array] all supported photo types
    def photo
      [PNG, JPEG, JPG, TIFF]
    end

    # All supported video types
    #
    # @return [Array] all supported video types
    def video
      [MOV, MP4, AVI, WMV]
    end

    # All supported audio types
    #
    # @return [Array] all supported audio types
    def audio
      [MP3]
    end

    # All supported archive types
    #
    # @return [Array] all supported archive types
    def archive
      [ZIP, TAR, GZIP]
    end

    # Returns true if the file is one of the
    # supported media types
    #
    # @param [String] file_name
    # @return [Boolean] true if the file is a valid type
    def valid?(file_name)
      all.include?(raw_type(file_name))
    end

    # Returns true if the file is an archive
    #
    # @param [String] file_name
    # @return [Boolean] true if the file is an archive
    def archive?(file_name)
      archive.include?(raw_type(file_name))
    end

    # Returns the {MediaFileType} for a given file name.  If
    # the file is not a supported media type, return nil.
    #
    # @param [String] file_name
    # @return [MediaFileType] the file type
    def for_file_name(file_name)
      raw_type = raw_type(file_name)

      return nil unless raw_type && valid?(file_name)

      all.detect { |mtype| mtype == raw_type }
    end

    # Strips the file type from the file name.
    # Returns nil if the file name does not
    # have an extension
    #
    # @param [String] file_name
    # @return [String] the raw file type
    def raw_type(file_name)
      dot_index = file_name.index('.')
      return nil unless dot_index && dot_index > 0

      file_name.split('.').last.downcase
    end
    private_class_method :raw_type

  end
end