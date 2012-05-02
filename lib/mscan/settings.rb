require 'singleton'

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

    # Returns an arbitrary setting given a setting's group and key
    #
    # @param [String] the settings group that the setting is located in
    # @param [String] the settings key associated with a particular setting
    # @return [String] the setting
    def setting(group, key)
      @settings[group][key]
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