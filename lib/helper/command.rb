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

    def self.pull_image_from_registry(name)
      "docker pull #{self.registry_image_name(name)}"
    end

    def self.stop_container(name)
      "docker stop $(docker ps -a | grep \"#{self.registry_image_name(name)}\" | awk '{ print $1 }') || true"
    end
    
    def self.rm_container(name)
      "docker rm $(docker ps -a | grep \"#{self.registry_image_name(name)}\" | awk '{ print $1 }') || true"
    end

    def self.rmi(name)
      "docker rmi -f $(docker images #{self.registry_image_name(name)} -q) || true"
    end

    def self.inspect_image(name)
      "docker inspect #{name}"
    end
    
    def self.extract_compose(name)
      "docker run -i --rm #{self.registry_image_name(name)} cat #{Application.properties.compose_path}"
    end

    def self.registry_image_name(name)
      "#{RegistryAuth.configuration.registry}/#{name}"
    end

    def self.docker_compose_down(path)
      "docker-compose -f #{path}/docker-compose.yml down || true"
    end

    def self.docker_compose_up(path)
      "docker-compose -f #{path} up -d"
    end

    def self.docker_compose_ps(path)
      "docker-compose -f #{path} ps"
    end

  end
end