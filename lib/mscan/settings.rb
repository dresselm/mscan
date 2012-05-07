require 'yaml'

module Mscan #nodoc
  # Wrapper for accessing configuration settings
  module Settings
    # singleton
    extend self

    # Setting file name
    SETTINGS_FILE='settings.yml'

    @_settings = {}
    attr_reader :_settings

    def load!(options={})
      deep_merge!(@_settings, load_settings(build_settings_file_path).merge(options))
    end

    def method_missing(name, *args, &block)
      # TODO need to fail if the name is unknown
      # fail(NoMethodError, "unkown setting #{name}", caller)
      @_settings[name.to_s]
    end

    def deep_merge!(target, data)
      merger = proc do |key, v1, v2|
        Hash == v1 && Hash == v2 ? v1.merge(v2, &merger) : v2
      end
      target.merge!(data, &merger)
    end
    private_class_method :deep_merge!

    def build_settings_file_path
      File.join( Dir.pwd, 'lib', 'mscan', SETTINGS_FILE )
    end
    private_class_method :build_settings_file_path

    def load_settings(settings_file_path)
      # TODO pull in rails deep_symbolize
      YAML.load_file( settings_file_path )
    end
    private_class_method :load_settings
  end
end