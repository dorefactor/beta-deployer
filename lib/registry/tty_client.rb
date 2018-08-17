require 'tty-command'

module Registry
  class TTYClient
    def initialize()
      @cmd = TTY::Command.new
      @authenticated = false
    end

    def login
      handle_block do 
        result = @cmd.run(Helper::Command.authenticate, input: "#{RegistryAuth.configuration.password}")
        @authenticated = result.success?
        {
          success: result.success?
        }
      end
    end

    def pull(name)
      handle_block do 
        login unless @authenticated
        result = @cmd.run(Helper::Command.pull_image(name))
        {
          success: result.success?
        }
      end
    end

    def inspect(name)
      handle_block do 
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

    protected
    
    def handle_block
      yield
    rescue Errno::ENOENT => e
      {
        success: false,
        message: e.to_s
      }
    rescue TTY::Command::ExitError => e
      {
        success: false,
        message: e.to_s
      }
    rescue Exception => e
      {
        success: false,
        message: "Unknow error: #{e.to_s}"
      }
    end

  end
end