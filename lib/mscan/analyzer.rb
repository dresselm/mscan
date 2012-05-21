module Mscan #nodoc
  # Analyzes metadata files and prepares information for reporting
  class Analyzer

    def analyze
      # TODO DRY same as scan
      media_dirs = Settings.scan_directories.map do |root_dir|
        MediaDir.find_media_dirs(root_dir)
      end.flatten

      meta_data_to_analyze = {}
      media_dirs.each do |media_dir|
        scan_dir = media_dir.path
        prepended_keys = Mscan::Meta::ScanFile.read(scan_dir).map do |k, v|
          ["#{scan_dir}/#{k}", v]
        end
        meta_data_to_analyze.merge!(Hash[prepended_keys])
      end

      Mscan::Meta::AnalysisFile.new(meta_data_to_analyze).write
    end

  end
end