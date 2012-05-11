module Mscan
  module MediaType
    extend self

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

    def all
      [] << photo << video
    end

    def photo
      [PNG, JPEG, JPG, TIFF]
    end

    def video
      [MOV, MP4, AVI, WMV]
    end

    def valid?(type)
      type = type.to_s.downcase
      all.flatten.include?(type)
    end

  end
end