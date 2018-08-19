require 'docker_registry2'

module Registry
  module StripeErrors

    def self.handle_block
      yield
    rescue DockerRegistry2::RegistryAuthenticationException => e 
      {
        success: false,
        message: 'RegistryAuthenticationException'
      }
    rescue DockerRegistry2::RegistryAuthorizationException => e 
      {
        success: false,
        message: 'RegistryAuthorizationException'
      }
    rescue DockerRegistry2::RegistryUnknownException => e
      {
        success: false,
        message: 'RegistryUnknownException'
      }
    rescue DockerRegistry2::RegistrySSLException => e
      {
        success: false,
        message: 'RegistrySSLException'
      }
    rescue DockerRegistry2::ReauthenticatedException => e
      {
        success: false,
        message: 'ReauthenticatedException'
      }
    rescue DockerRegistry2::UnknownRegistryException => e
      {
        success: false,
        message: 'UnknownRegistryException'
      }
    rescue DockerRegistry2::NotFound => e
      {
        success: false,
        message: 'NotFound'
      }
    rescue DockerRegistry2::InvalidMethod => e
      {
        success: false,
        message: 'InvalidMethod'
      }
    end
  end
end