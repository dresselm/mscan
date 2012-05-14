module Mscan
  module MediaType
    extend self

    class MediaTypeError < ::Exception; end
    class NoExtension < MediaTypeError; end
    class UnknownType < MediaTypeError; end

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

    # ARCHIVE FORMATS
    ZIP  = 'zip'
    TAR  = 'tar'
    GZIP = 'gz'

    # All supported media types
    #
    # @return [Array] all supported media types
    def all
      ([] << photo << video).flatten
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

    # All supported archive types
    #
    # @return [Array] all supported archive types
    def archive
      [ZIP, TAR, GZIP]
    end

    # Returns true if the file type is one of the
    # supported media types
    #
    # @param [String, Symbol] file_type
    # @return [Boolean] all supported media types
    def valid?(type)
      type = type.to_s.downcase
      all.include?(type)
    end

    # Returns the {MediaType} for a given file name
    #
    # @param [String] file_name
    # @return [MediaType] the file type
    def for_file_name(file_name)
      raise NoExtension, "No extension for #{file_name}" unless file_name.include?('.')

      raw_type = file_name.split('.').last.downcase
      media_type = all.detect {|mtype| mtype == raw_type}
      raise UnknownType, "Unable to determine the type for #{file_name}" if media_type.nil?

      media_type
    end

  end
end