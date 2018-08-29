module Menu
  class Main

    def initialize
      @options = [
        'Deploy an image',
        '<< Exit'
      ]
      @registy_client = Registry::Client.new
    end

    def select_options
      print_header
      selected_option = Menu.prompt.select('Choose an image', @options )

      case selected_option
      when '<< Exit'
        puts "Byeee"
        return RegularDeployer::MenuResult.new(false)
      when 'Deploy an image'
        select_image_from_catalog
        RegularDeployer::MenuResult.new(true)
      end
    end

    def select_image
      result_catalog = @registy_client._catalog_v2
      images = build_option_response(result_catalog, 'repositories')
      
      unless images.continue?
        return RegularDeployer::MenuResult.new(false)
      end
      
      prompt_options('Select an image: ', images.options)
    end

    def select_tag(selected_image)
      result_tags = @registy_client.tags(selected_image)
      tags = build_option_response(result_tags, 'tags')

      unless tags.continue?
        return RegularDeployer::MenuResult.new(false)
      end

      prompt_options('Select an tag: ', tags.options)
    end

    def select_image_from_catalog
      
      selected_image = select_image
      return unless selected_image.valid?

      selected_tag = select_tag(selected_image.option)
      return unless selected_tag.valid?

      Helper::Logging.debug("Image to deploy: #{selected_image.option}:#{selected_tag.option}")
    end
    
    private
    
    def prompt_options(title, options)
      selected = Menu.prompt.select(title, options)
      RegularDeployer::SelectedOptionResult.new(selected)
    end

    def print_header
      puts %{
        Welcome to RegularDeployer version 0.1}
    end

    def build_option_response(result, source)
      choices = result.success? ? result.out[source]  : Array.new
      choices << "<< Back"
      RegularDeployer::MenuResult.new(result.success?, choices)
    end

  end
end