module Mscan #nodoc
  # Media directory wrapper
  class MediaDir

    class Error < RuntimeError; end #nodoc
    # Raised if the supplied path does not represent a valid directory
    class InvalidPathError < Error; end

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
    def media
      media = []
      entities.each do |entity|
        entity_path = "#{path}/#{entity}"
        next unless Media.valid?(entity_path)
        media << Media.new(entity_path)
      end
      media
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
      raise MediaDir::InvalidPathError, "Unable to find media directories.  #{root_path} does not exist!" unless File.directory?(root_path)

      media_directories = []
      Find.find(root_path) do |path|
        # Paths are relative to the working directory
        if File.directory?(path)
          # Find.prune if File.basename(path)[0] == ?.
          media_directories << MediaDir.new(path)
        end
      end
      media_directories
    end

  end
end