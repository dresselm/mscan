module Mscan
  class MediaDir
    attr_reader :path

    def initialize(dir_path)
      @path = dir_path
    end

    # Returns a list of all Mscan::MediaDirs under a given path
    #
    # @param [String] the root path
    # @return [Array] an array of Mscan::MediaDir
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