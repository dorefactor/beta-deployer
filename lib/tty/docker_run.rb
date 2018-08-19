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
        {
          success: result.success?
        }
      end
    end

    def pull(name)
      TTY::StripeErrors.handle_block do 
        login unless @authenticated
        result = @cmd.run(Helper::Command.pull_image(name))
        {
          success: result.success?
        }
      end
    end

    def inspect(name)
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.inspect_image(name))
      
        if result.success?
          {
            success: true,
            labels: Helper::ImageContent.parse_inspect(result.out)
          }
        else
          {
            success: false,
            message: result.err
          }
        end
      end
    end
   
    def inspect(name)
      TTY::StripeErrors.handle_block do 
        result = @cmd.run(Helper::Command.inspect_image(name))
      
        if result.success?
          {
            success: true,
            labels: Helper::ImageContent.parse_inspect(result.out)
          }
        else
          {
            success: false,
            message: result.err
          }
        end
      end
    end

    def extract_compose(name)
      TTY::StripeErrors.handle_block do
        result = @cmd.run(Helper::Command.extract_compose(name))

        unless result.success?
          return {
            success: false,
            message: result.err
          }
        end

        if Helper::Compose.validate(YAML.load(result.out))
          {
            success: true,
            compose_content: result.out
          }
        else
          {
            success: false,
            message: "The content for compose is invalid"
          }
        end
      end
    end
    
  end
end