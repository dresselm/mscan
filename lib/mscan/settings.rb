require 'singleton'

module Mscan #nodoc

  # Wrapper for accessing configuration settings
  class Settings
    include Singleton

    SETTINGS_FILE='config.yml'

    def initialize
      @settings = load_settings
    end

    def attribute(group, key)
      @settings[group][key]
    end

    def load_settings
      YAML.load_file( File.join( Dir.pwd, 'lib', 'mscan', SETTINGS_FILE ) )
    end
    private :load_settings
  end
end