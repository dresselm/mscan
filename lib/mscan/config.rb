module Mscan #nodoc

  class Config
    CONFIGURATION_FILE='config.yml'

    def attribute(group, key)
      load_configuration[group][key]
    end

    def load_configuration
      YAML.load_file( File.join( Dir.pwd, 'config', CONFIGURATION_FILE ) )
    end
    private :load_configuration
  end
end