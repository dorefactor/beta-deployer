module Application
  def self.properties
    @properties ||= Propierty.new
  end

  def self.configure
    yield properties
  end

  class Propierty
    attr_accessor :compose_path
    
    def initialize
      properties_on_file = YAML.load_file("#{Dir.pwd}/lib/config/application_properties.yml")
      @compose_path = properties_on_file['compose_path'] || '/opt/dorefactor/docker-compose.yml'
    end
  end
end
