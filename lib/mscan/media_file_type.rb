module Mscan # :nodoc:
  # Supported file types and file type helper methods.
  #
  # Common file formats referenced from this list:
  # http://www.fileinfo.com/filetypes/common
  module MediaFileType
    extend self

    class MediaFileTypeError < RuntimeError; end # :nodoc:
    # Raised when the file type extension is missing
    class NoExtensionError < MediaFileTypeError; end
    # Raised when the file type is unknown
    class UnknownTypeError < MediaFileTypeError; end

    # TODO move these all in a yaml file and
    # build the constants, desriptions and groups dynamically

    # IMAGE/PHOTO FORMATS
    # Adobe Illustrator File
    AI   = 'ai'
    # Bitmap
    BMP  = 'bmp'
    # Encapsulated PostScript File
    EPS  = 'eps'
    # Graphical Interchange Format File
    GIF  = 'gif'
    # Joint Photographic Experts Group
    JPEG = 'jpeg'
    # Joint Photographic Experts Group (Alternate representation)
    JPG  = 'jpg'
    # Portable Network Graphics
    PNG  = 'png'
    # Adobe Photoshop Document
    PSD  = 'psd'
    # Scalable Vector Graphics File
    SVG  = 'svg'
    # Tagged Image File Format
    TIFF = 'tiff'

    # VIDEO FORMATS
    # Audio Video Interleave File
    AVI  = 'avi'
    # Flash Video
    FLV  = 'flv'
    # Apple QuickTime Movie
    MOV  = 'mov'
    # MPEG Video File
    MPG  = 'mpg'
    # MPEG-4 Video File
    MP4  = 'mp4'
    # Real Media File
    RM   = 'rm'
    # Shockwave Flash Movie
    SWF  = 'swf'
    # Windows Media Video File
    WMV  = 'wmv'

    # AUDIO FORMATS
    # Audio Interchange File Format
    AIF  = 'aif'
    # MP3 Audio File
    MP3  = 'mp3'
    # MPEG-2 Audio File
    MPA  = 'mpa'
    # MPEG-4 Audio File
    M4A  = 'm4a'
    # MIDI FILE
    MID  = 'mid'
    # Real Audio File
    RA   = 'ra'
    # WAVE Audio File
    WAV  = 'wav'
    # Windows Media Audio File
    WMA  = 'wma'

    # ARCHIVE FORMATS
    # Zipped File
    ZIP  = 'zip'
    # Consolidated Unix File Archive
    TAR  = 'tar'
    # Gnu Zipped Archive
    GZIP = 'gz'
    # WinRAR Compressed Archive
    RAR  = 'rar'

    # TEMPORARY FORMATS
    # Backup File
    BAK  = 'bak'
    # Temporary File
    TMP  = 'tmp'

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
      [AI, BMP, EPS, GIF, JPEG, JPG, PNG, PSD, SVG, TIFF]
    end

    # All supported video types
    #
    # @return [Array] all supported video types
    def video
      [AVI, FLV, MOV, MPG, MP4, RM, SWF, WMV]
    end

    # All supported audio types
    #
    # @return [Array] all supported audio types
    def audio
      [AIF, MP3, MPA, M4A, MID, RA, WAV, WMA]
    end

    # All supported archive types
    #
    # @return [Array] all supported archive types
    def archive
      [ZIP, TAR, GZIP, RAR]
    end

    # All supported temp types
    #
    # @return [Array] all supported temp types
    def temp
      [BAK, TMP]
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

    # Returns true if the file is a temp file
    #
    # @param [String] file_name
    # @return [Boolean] true if the file is a temp file
    def temp?(file_name)
      temp.include?(raw_type(file_name))
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
    # have an extension.
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