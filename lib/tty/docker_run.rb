require 'tty/stripe_errors'

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

    def pull(name)
      TTY::StripeErrors.handle_block do 
        login unless @authenticated
        result = @cmd.run(Helper::Command.pull_image(name))
        RegularDeployer::Result.new(result.success?, result.out, result.err)
      end
    end

    def inspect(name)
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.inspect_image(name))
        RegularDeployer::Result.new(result.success?, result.out, result.err)
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