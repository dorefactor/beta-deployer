module Menu
  class InteractorMain

    def initialize
      @action_options = [
        'Deploy an image',
        'List containers',
        '<< Exit'
      ]

      @registy_http_client = Registry::HttpClient.new
    end

    def select_action
      print_header
      prompt_options('Select an action: ', @action_options)
    end

    def select_image
      result_catalog = @registy_http_client._catalog_v2
      images = build_option_response(result_catalog, 'repositories')
      
      unless images.continue?
        return RegularDeployer::MenuResult.new(false)
      end
      
      prompt_options('Select an image: ', images.options)
    end

    def select_tag(selected_image)
      result_tags = @registy_http_client.tags(selected_image)
      tags = build_option_response(result_tags, 'tags')

      unless tags.continue?
        return RegularDeployer::MenuResult.new(false)
      end

      prompt_options('Select an tag: ', tags.options)
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