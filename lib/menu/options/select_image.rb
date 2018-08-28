module Menu
  module Options
    class SelectImage
      def initialize(registy_client)
        @registy_client = registy_client
      end

      def get_images
        result_catalog = @registy_client._catalog_v2
        build_option_response(result_catalog, 'repositories')
      end

      def get_tags(image)
        result_tag = @registy_client.tags(image)
        build_option_response(result_catalog, 'tags')
      end

      private

      def build_option_response(result, source)
        choices = result.success? ? result.out[source]  : Array.new
        choices << "<< Back"
        RegularDeployer::MenuResult.new(result.success?, choices)
      end
    end
  end
end
