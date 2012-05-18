module Mscan #nodoc
  # Analyzes metadata files and prepares information for reporting
  class Analyzer

    def analyze
      # TODO DRY same as scan
      media_dirs = Settings.scan_directories.map do |root_dir|
        MediaDir.find_media_dirs(root_dir)
      end.flatten

      meta_data_to_analyze = media_dirs.map do |media_dir|
        # TODO prepend the media_dir.path to each key
        Mscan::Meta::ScanFile.read(media_dir.path)
      end

      Mscan::Meta::AnalysisFile.new(transform_meta_data(meta_data_to_analyze)).write
    end

    # TODO transform the meta_data into fingerprint => [MediaFile1, MediaFile2, etc]
    def transform_meta_data(meta_data)
      meta_data
    end

  end
end