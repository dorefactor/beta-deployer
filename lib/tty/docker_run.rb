require 'tty/stripe_errors'
require 'tty-command'
module TTY
  class DockerRun
    def initialize()
      @cmd = TTY::Command.new
      @authenticated = false
    end

    def login
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.authenticate, input: "#{RegistryAuth.configuration.password}")
        @authenticated = result.success?
        RegularDeployer::Result.new(result.success?, result.out, result.err)
      end
    end

    def clean_image(name)
      @cmd.run(Helper::Command.stop_container(name), only_output_on_error: true)
      @cmd.run(Helper::Command.rm_container(name), only_output_on_error: true)
      @cmd.run(Helper::Command.rmi(name),  only_output_on_error: true)
    end

    def pull(name)
      TTY::StripeErrors.handle_block do 
        login unless @authenticated
        result = @cmd.run(Helper::Command.pull_image(name))
        RegularDeployer::Result.new(result.success?, result.out, result.err)
      end
    end

    def pull_from_registry(name)
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.pull_image_from_registry(name))
        RegularDeployer::Result.new(result.success?, result.out, result.err)
      end
    end

    def inspect(name)
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.inspect_image(name))
        RegularDeployer::Result.new(result.success?, result.out, result.err)
      end
    end

    def docker_compose_down(path)
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.docker_compose_down(path), only_output_on_error: true)
        RegularDeployer::Result.new(result.success?, result.out, result.err)
      end
    end

    def docker_compose_up(path)
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.docker_compose_up(path))
        RegularDeployer::Result.new(result.success?, result.out, result.err)
      end
    end

    def docker_compose_ps(path)
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.docker_compose_ps(path))
        RegularDeployer::Result.new(result.success?, result.out, result.err)
      end
    end

    def docker_general_ps
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.docker_ps)
        # RegularDeployer::Result.new(result.success?, result.out, result.err)
      end
    end
    
    def extract_compose(name)
      TTY::StripeErrors.handle_block do
        result = @cmd.run(Helper::Command.extract_compose(name))

        compose_content_validation = Helper::Compose.validate(YAML.load(result.out))
        if compose_content_validation
          RegularDeployer::Result.new(result.success?, result.out, result.err)
        else
          RegularDeployer::Result.create_error('The content for compose is invalid')
        end
      end
    end
    
  end
end