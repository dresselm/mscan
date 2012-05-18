module Mscan #nodoc
  # Analyzes metadata files and prepares information for reporting
  class Analyzer

    def analyze
      # TODO DRY same as scan
      media_dirs = Settings.scan_directories.map do |root_dir|
        MediaDir.find_media_dirs(root_dir)
      end.flatten

      meta_data_to_analyze = media_dirs.map do |media_dir|
        puts "Prepend #{media_dir.path} to each key"
        ScanFile.read(media_dir.path)
      end

      # TODO Write the basic analysis to a timestamped file that can be consumed by the reporter
    end

  end
end