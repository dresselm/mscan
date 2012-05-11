require 'yaml'

module Mscan #nodoc
  # Wrapper for accessing configuration settings
  module Settings
    # singleton
    extend self

    # Setting file name
    SETTINGS_FILE='settings.yml'

    @_settings = nil
    attr_reader :_settings

    def load!(options={})
      @_settings ||= load_settings
      deep_merge!(@_settings, options)
    end

    # nodoc
    def method_missing(name, *args, &block)
      # TODO need to fail if the name is unknown
      # fail(NoMethodError, "unkown setting #{name}", caller)
      @_settings[name.to_s]
    end

    # nodoc
    def deep_merge!(target, data)
      merger = proc do |key, v1, v2|
        Hash == v1 && Hash == v2 ? v1.merge(v2, &merger) : v2
      end
      target.merge!(data, &merger)
    end
    private_class_method :deep_merge!

    # nodoc
    def load_settings
      puts "loading settings file"
      # TODO pull in rails deep_symbolize
      YAML.load_file( build_settings_file_path )
    end
    private_class_method :load_settings

    # nodoc
    def build_settings_file_path
      File.join( Dir.pwd, 'lib', 'mscan', SETTINGS_FILE )
    end
    private_class_method :build_settings_file_path

  end
end