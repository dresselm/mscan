module Mscan #nodoc
  # Media directory wrapper
  class MediaDir
    attr_reader :path

    def initialize(dir_path)
      @path = dir_path
    end

    # Returns a list of all files and directories in
    # this {MediaDir}
    #
    # @return [Array] files and directories in this {MediaDir}
    # TODO come up with a better name
    def entities
      @entities ||= Dir.entries(@path)
    end

    # Returns all {Media} files in this {MediaDir}
    #
    # @return [Array] all {Media} files in this {MediaDir}
    # TODO come up with a better name
    def medias
      medias = []
      entities.each do |entity|
        entity_path = "#{path}/#{entity}"
        next unless Media.valid?(entity_path)
        medias << Media.new(entity_path)
      end
      medias
    end


    def to_params(*args)
      ordered_hash = {}
      medias.sort_by(&:name).each do |media|
        ordered_hash[media.name] = media.to_params(*args)
      end
      ordered_hash
    end

    # Returns a list of all {Mscan::MediaDir} objects under a given path
    #
    # @param [String] root_path the root path
    # @return [Array] an array of {Mscan::MediaDir} objects
    def self.find_media_dirs(root_path)
      raise RuntimeError, "Unable to find media directories.  #{root_path} does not exist!" unless File.directory?(root_path)

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