require 'find'

module Mscan #nodoc
  # Scans directories, instruments media files and stores
  # the instrumentation data in metadata files
  class Scanner

    # Scans the  directory for media files.
    def scan
      media_dirs = Settings.scan_directories.map do |root_dir|
        MediaDir.find_media_dirs(root_dir)
      end.flatten

      media_dirs.each do |media_dir|
        save_meta_data(media_dir.path, media_dir.to_params(:fingerprint))
      end
    end

    def save_meta_data(path, meta_data)
      Metadata.write(path, meta_data)
    end
    private :save_meta_data

  end
end