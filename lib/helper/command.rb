module Helper
  class Command
    
    def self.authenticate
      %{
        docker login #{RegistryAuth.configuration.host} \
        -u #{RegistryAuth.configuration.user} --password-stdin
      }
    end

    def self.pull_image(name)
      "docker pull #{name}"
    end

    def self.inspect_image(name)
      "docker inspect #{name}"
    end
    
    def self.extract_compose(name)
      "docker run -i --rm #{name} cat #{Application.properties.compose_path}1"
    end

    def self.registry_image_name(name)
      "#{RegistryAuth.configuration.registry}/#{name}"
    end
  end
end