module Mscan # :nodoc:
  # Media directory wrapper
  class MediaDir

    class Error < RuntimeError; end # :nodoc:
    # Raised if the supplied path does not represent a valid directory
    class InvalidPathError < Error; end

    attr_reader :path

    def initialize(dir_path='.')
      @path = dir_path
    end

    # Returns a list of all {MediaDir media directories} for the configured
    # scan directories. Inclusive of each {MediaDir scan directory}.
    #
    # @return [Array] an array of {MediaDir directories}
    def self.find_all_media_dirs
      Mscan::Config.scan_directories.map do |root_dir|
        find_media_dirs(root_dir)
      end.flatten
    end

    # Returns a list of the entire {MediaDir directory} tree for the given fully
    # qualified path. Inclusive of the root directory.
    #
    # @param [String] root_path
    # @return [Array] an array of {MediaDir directories}
    def self.find_media_dirs(root_path)
      unless File.directory?(root_path)
        raise InvalidPathError, "Unable to find media directories.  #{root_path} does not exist!"
      end

      media_directories = []
      Find.find(root_path) do |path|
        # Paths are relative to the working directory
        if File.directory?(path)
          Find.prune if skip_directory?(path)
          media_directories << MediaDir.new(path)
        end
      end
      media_directories
    end

    def self.skip_directory?(path)
      name      = File.basename(path)
      extension = File.extname(name)

      name[0] == ?. || MediaFileType::SKIP_TYPES.include?(extension)
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
      media.sort_by(&:path)
    end

    # Returns a parameter hash representing the {MediaFile files} within
    # the {MediaDir current directory}. The hash contains a timestamp
    # and a list of all media_files
    #
    # @param [Array] args optional arguments to pass through to each {MediaFile file}
    # @return [Object] parameter hash
    def to_params(*args)
      meta_data   = {:timestamp => Time.now.to_i, :media_files => []}
      media_files = meta_data[:media_files]
      sorted_media.each do |media_file|
        media_files << media_file.to_params(*args)
      end
      meta_data
    end

  end
end