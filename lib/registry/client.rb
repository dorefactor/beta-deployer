require 'docker_registry2'
require 'registry/stripe_errors'

module Registry
  class Client

    def initialize(host = RegistryAuth.configuration.host, user = RegistryAuth.configuration.user, password = RegistryAuth.configuration.password)
      Registry::StripeErrors.handle_block do
        opts = {
          user:     user, 
          password: password
        }
        Helper::Logging.info("Logging to registry: #{RegistryAuth.configuration.host}....")
        @client = DockerRegistry2.connect(host, opts)
        @login = true
        Helper::Logging.info("logged: #{@login}")
      end
    end

    def login?
      @login
    end

    def ping
      Registry::StripeErrors.handle_block do
        Helper::Logging.info("Ping to registry: #{RegistryAuth.configuration.host}....")
        result = @client.ping
        RegularDeployer::Result.create_successful result
      end
    end

    def _catalog_v2(limit = '?n=100')
      Registry::StripeErrors.handle_block do
        Helper::Logging.info("Loading /v2/_catalog#{limit} from Registry....")
        result = JSON.parse(@client.doget("/v2/_catalog#{limit}"))
        RegularDeployer::Result.new(true, result, :empty)
      end
    end

    def tags(name)
      Registry::StripeErrors.handle_block do
        withHashes = true
        Helper::Logging.info('Loading tags....')
        result = @client.tags(name, withHashes)
        RegularDeployer::Result.new(true, result, :empty)
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