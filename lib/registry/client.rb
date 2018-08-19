require 'docker_registry2'
require 'registry/stripe_errors'

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
      Registry::StripeErrors.handle_block do
        withHashes = true
        @client.tags(name, withHashes)
      end
    end

    def manifest(name, tag)
      Registry::StripeErrors.handle_block do
        @client.manifest(name, tag)
      end
    end

    def pull(name, tag, dir ='/Users/drecinos/stash/docker/regular-deployer/tmp')
      Registry::StripeErrors.handle_block do
        @client.pull(name, tag, dir)
      end
    end
   
  end
end