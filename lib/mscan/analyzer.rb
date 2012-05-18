module Mscan #nodoc
  # Analyzes metadata files and prepares information for reporting
  class Analyzer

    ANALYSIS_OUTPUT_PATH = 'analysis'

    def analyze
      # TODO DRY same as scan
      media_dirs = Settings.scan_directories.map do |root_dir|
        MediaDir.find_media_dirs(root_dir)
      end.flatten

      meta_data_to_analyze = media_dirs.map do |media_dir|
        # TODO prepend the media_dir.path to each key
        Mscan::Meta::ScanFile.read(media_dir.path)
      end

      # TODO transform the meta_data into fingerprint => [MediaFile1, MediaFile2, etc]
      # TODO analyze the meta_data_to_analyze object and output to analysis file
      Mscan::Meta::AnalysisFile.write(ANALYSIS_OUTPUT_PATH, meta_data_to_analyze, true)

    end

  end
end