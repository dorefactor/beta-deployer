module RegistryAuth
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  class Configuration
    attr_accessor :host
    attr_accessor :registry
    attr_accessor :user
    attr_accessor :password
    
    def initialize
      @host     = ENV['REGISTRY_HOST'] || 'host'
      @user     = ENV['REGISTRY_USER'] || 'user'
      @password = ENV['REGISTRY_PASS'] || 'pass'
      @registry = @host.gsub(/http(s)*\:\/\//, '')
    end
  end
end
