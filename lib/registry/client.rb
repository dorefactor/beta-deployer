require 'docker_registry2'

module Registry
  class Client
    def initialize(host = RegistryAuth.configuration.host, user = RegistryAuth.configuration.user, password = RegistryAuth.configuration.password)
      opts = {
        user:     user, 
        password: password
      }
      @client = DockerRegistry2.connect(host, opts)
    end

    def ping
      @client.ping
    end

    def _catalog_v2(limit = '?n=100')
      @client.doget("/v2/_catalog")
    end

    def tags(name)
      handle_stripe_errors do
        withHashes = true
        @client.tags(name, withHashes)
      end
    end

    def manifest(name, tag)
      handle_stripe_errors do
        @client.manifest(name, tag)
      end
    end

    def pull(name, tag, dir ='/Users/drecinos/stash/docker/regular-deployer/tmp')
      handle_stripe_errors do
        @client.pull(name, tag, dir)
      end
    end

    private

    def handle_stripe_errors
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