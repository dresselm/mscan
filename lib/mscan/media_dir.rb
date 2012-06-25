module Mscan #nodoc
  # Media directory wrapper
  class MediaDir

    class Error < RuntimeError; end #nodoc
    # Raised if the supplied path does not represent a valid directory
    class InvalidPathError < Error; end

    attr_reader :path

    def initialize(dir_path='.')
      @path = dir_path
    end

    # Returns a list of all files and directories in
    # this {MediaDir directory}
    #
    # @return [Array] files and directories in this {MediaDir directory}
    def entities
      @entities ||= Dir.entries(@path)
    end

    # Returns all {MediaFile files} in this {MediaDir directory}
    #
    # @return [Array] all {MediaFile files} in this {MediaDir directory}
    def media
      media = []
      entities.each do |entity|
        entity_path = "#{path}/#{entity}"
        next unless MediaFile.valid?(entity_path)
        media << MediaFile.new(entity_path)
      end
      media
    end

    # Sorts media by path name
    #
    # @return [Array] sorted {MediaFile media files}
    def sorted_media
      media.sort_by(&:name)
    end

    # Returns a parameter hash representing the {MediaFile files} within
    # the {MediaDir current directory}. The hash is ordered by {MediaFile file} name.
    #
    # @param [Array] args optional arguments to pass through to each {MediaFile file}
    # @return [Object] parameter hash
    def to_params(*args)
      ordered_hash = {}
      sorted_media.each do |media_file|
        ordered_hash[media_file.name] = media_file.to_params(*args)
      end
      ordered_hash
    end

    # Returns a list of all {MediaDir media directories} for the configured
    # scan directories. Inclusive of each {MediaDir scan directory}.
    #
    # @return [Array] an array of {MediaDir directories}
    def self.find_all_media_dirs
      Settings.scan_directories.map do |root_dir|
        find_media_dirs(root_dir)
      end.flatten
    end

    # Returns a list of the entire {MediaDir directory} tree for the given path.
    # Inclusive of the root directory.
    #
    # @param [String] root_path
    # @return [Array] an array of {MediaDir directories}
    def self.find_media_dirs(root_path)
      raise InvalidPathError, "Unable to find media directories.  #{root_path} does not exist!" unless File.directory?(root_path)

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