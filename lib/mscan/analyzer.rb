module Mscan #nodoc
  # Analyzes metadata files and prepares information for reporting
  class Analyzer

    # ANALYZERS = [Analysis::Redundancy, Analysis::Type]

    attr_reader :raw_meta_data, :transformed_meta_data

    def analyze
      Profiler.measure('Analyzing') do
        @raw_meta_data = Mscan::Meta::ScanFile.read_aggregate

        # TODO Pass raw meta data through a series of filters
        #   ANALYZERS.each do |a|
        #     # each analzer will analyze the raw meta_data and
        #     # save an analysis file for later consumption
        #     a.analyze(@raw_meta_data)
        #   end
        @transformed_meta_data = transform_meta_data

        save
      end
    end

    # Call this from each Analysis processor
    def save
      Mscan::Meta::AnalysisFile.new(self).write
    end


    def self.total_size(media_files)
      media_files.inject(0) {|total_size, media_file| total_size + media_file['size']}
    end

    def self.total_number_files(meta_data_hash)
      meta_data_hash.keys.size
    end

    # index by fingerprint
    def transform_meta_data
      fingerprint_hash = {}
      @raw_meta_data.each do |k, v|
        fingerprint = v.delete('fingerprint')
        if obj = fingerprint_hash[fingerprint]
          obj[:media] << v.merge(:path => k)
        else
          fingerprint_hash[fingerprint] = {:media => [v.merge(:path => k)]}
        end
      end
      fingerprint_hash
    end
    private :transform_meta_data

  end
end