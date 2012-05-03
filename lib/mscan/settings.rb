require 'singleton'
require 'yaml'

module Mscan #nodoc

  # Wrapper for accessing configuration settings
  class Settings
    include Singleton

    # Setting file name
    SETTINGS_FILE='settings.yml'

    def initialize(file_path=nil)
      settings_file_path = build_settings_file_path(file_path)
      @settings = load_settings(settings_file_path)
    end

    # Returns an arbitrary setting given the setting's key
    #
    # TODO Improve this api:
    #   Mscan::Settings.instance.settings('supported_image_file_types')
    #
    #   Mscan::Settings.instance.supported_image_file_types
    #   Mscan::Settings.instance[:supported_image_file_types]
    #
    # @param [String] the key associated with a given settings
    # @return [String] the setting
    def setting(key)
      @settings[key]
    end

    def build_settings_file_path(settings_file_path)
      settings_file_path || File.join( Dir.pwd, 'lib', 'mscan', SETTINGS_FILE )
    end
    private :build_settings_file_path

    def load_settings(settings_file_path)
      YAML.load_file( settings_file_path )
    end
    private :load_settings
  end
end