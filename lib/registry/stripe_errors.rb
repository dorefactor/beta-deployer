require 'docker_registry2'

module Registry
  module StripeErrors

    def self.handle_block
      yield
    rescue DockerRegistry2::RegistryAuthenticationException => e 
      RegularDeployer::Result.create_error('RegistryAuthenticationException')
    rescue DockerRegistry2::RegistryAuthorizationException => e 
      RegularDeployer::Result.create_error('RegistryAuthorizationException')
    rescue DockerRegistry2::RegistryUnknownException => e
      RegularDeployer::Result.create_error('RegistryUnknownException')
    rescue DockerRegistry2::RegistrySSLException => e
      RegularDeployer::Result.create_error('RegistrySSLException')
    rescue DockerRegistry2::ReauthenticatedException => e
      RegularDeployer::Result.create_error('ReauthenticatedException')
    rescue DockerRegistry2::UnknownRegistryException => e
      RegularDeployer::Result.create_error('UnknownRegistryException')
    rescue DockerRegistry2::NotFound => e
      RegularDeployer::Result.create_error('NotFound')
    rescue DockerRegistry2::InvalidMethod => e
      RegularDeployer::Result.create_error('InvalidMethod')
    end
  end
end