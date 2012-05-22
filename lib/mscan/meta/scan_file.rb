module Mscan::Meta
  class ScanFile
    include Mscan::MetaFile

    def self.write_aggregate(aggregate_content)
      write(AnalysisFile::ANALYSIS_OUTPUT_DIR, aggregate_content, true)
    end

    def self.read_aggregate
      read_most_recent(AnalysisFile::ANALYSIS_OUTPUT_DIR)
    end
  end
end