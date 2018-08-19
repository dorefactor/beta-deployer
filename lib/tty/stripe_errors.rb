module TTY
  module StripeErrors
    def self.handle_block
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