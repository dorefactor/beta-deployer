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
      @host     = ENV['REGISTRY_HOST'] || 'https://apps.cavitos.ne'
      @user     = ENV['REGISTRY_USER'] || 'drecinos'
      @password = ENV['REGISTRY_PASS'] || 'Fagoner##20'
      @registry = @host.gsub(/http(s)*\:\/\//, '')
    end
  end
end
