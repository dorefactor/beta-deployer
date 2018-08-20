module TTY
  module StripeErrors
    def self.handle_block
      yield
    rescue Errno::ENOENT => e
      RegularDeployer::Result.create_error(e.to_s)
    rescue TTY::Command::ExitError => e
      RegularDeployer::Result.create_error(e.to_s)
    rescue Exception => e
      RegularDeployer::Result.create_error(e.to_s)
    end
  end
end