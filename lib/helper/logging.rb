require 'logger'
module Helper
  class Logging

    class << self
      attr_accessor :logger_instance 
    end

    def self.log
      self.logger_instance ||= Logger.new(STDOUT)
    end

    def self.debug(message)
      self.log.debug message
    end

    def self.info(message)
      self.log.info message
    end
  end
end