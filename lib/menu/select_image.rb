module Menu
  class SelectImage
    
    def self.select_options
      registy_client = Registry::Client.new
      result_catalog = registy_client._catalog_v2
      
      images = self.build_option_response(result_catalog, 'repositories')

      unless images.continue?
        puts "There was an error with the images"
        return images
      end

      selected_option = Menu.prompt.select('Choose an image', images.options )

      
      
      
    end



    # def get_tags(image)
    #   result_tag = @registy_client.tags(image)
    #   build_option_response(result_catalog, 'tags')
    # end

    

    def self.build_option_response(result, source)
      choices = result.success? ? result.out[source]  : Array.new
      choices << "<< Back"
      RegularDeployer::MenuResult.new(result.success?, choices)
    end



     
  end
end