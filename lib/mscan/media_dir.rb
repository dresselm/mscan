module Mscan #nodoc
  class MediaDir
    attr_reader :path

    def initialize(dir_path)
      @path = dir_path
    end

    def entities
      @entities ||= Dir.entries(@path)
    end

    # Returns all {Media} files in this {MediaDir}
    def medias
      medias = []
      entities.each do |entry|
        next unless Media.valid?("#{path}/#{entry}")
        medias << entry
      end
      medias
    end

    def to_params
      ordered_hash = {}
      medias.sort(&:name).each do |media|
        order_hash[media.name] = media.to_params
      end
      ordered_hash
    end

    # Returns a list of all {Mscan::MediaDir} objects under a given path
    #
    # @param [String] root_path the root path
    # @return [Array] an array of {Mscan::MediaDir} objects
    def self.find_media_dirs(root_path)
      media_directories = []
      Find.find(root_path) do |path|
        # Paths are relative to the working directory
        if File.directory?(path)
          # Find.prune if File.basename(path)[0] == ?.
          media_directories << Mscan::MediaDir.new(path)
        end
      end
      media_directories
    end

  end
end