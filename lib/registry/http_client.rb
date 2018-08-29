require 'json'

module Registry
  class HttpClient

    def initialize
      @http = Net::HTTP.new(RegistryAuth.configuration.registry, 443)
      @http.use_ssl = true
    end

    def ping
      stripe_error do
        @http.start do |http|
          request = create_get_request('/v2/')
          perform_request(http, request) 
        end
      end
    end

    def _catalog_v2(limit = '?n=200')
      stripe_error do
        @http.start do |http|
          request = create_get_request("/v2/_catalog#{limit}")
          perform_request(http, request) 
        end
      end
    end

    def tags(image)
      stripe_error do
        @http.start do |http|
          request = create_get_request("/v2/#{image}/tags/list")
          perform_request(http, request) 
        end
      end
    end

    def perform_request(http, request)
      response = http.request(request)
      response.value
      result = JSON.parse(response.body)
      RegularDeployer::Result.new(true, result, :empty)
    end

    def create_get_request(path)
      request = Net::HTTP::Get.new(path)
      request.basic_auth RegistryAuth.configuration.user, RegistryAuth.configuration.password
      request
    end

    private

    def stripe_error
      yield
    rescue Net::HTTPServerException => e
      Helper::Logging.error e.to_s
      RegularDeployer::Result.new(false, :empty, e.to_s)
    rescue Exception => e
      Helper::Logging.error e.to_s
      RegularDeployer::Result.new(false, :empty, e.to_s)
    end

  end
end