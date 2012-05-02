require 'singleton'

module Mscan #nodoc

  # Wrapper for accessing configuration settings
  class Settings
    include Singleton

    # Setting file name
    SETTINGS_FILE='config.yml'

    def initialize
      @settings = load_settings
    end

    # Returns an arbitrary setting given a setting's group and key
    #
    # @param [String] the settings group that the setting is located in
    # @param [String] the settings key associated with a particular setting
    # @return [String] the setting
    def setting(group, key)
      @settings[group][key]
    end

    def load_settings
      YAML.load_file( File.join( Dir.pwd, 'lib', 'mscan', SETTINGS_FILE ) )
    end
    private :load_settings
  end
end