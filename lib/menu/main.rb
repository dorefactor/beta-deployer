require_relative './interactor_main'

module Menu
  class Main

    def initialize
      @main_interactor = Menu::InteractorMain.new
      @deployer = Deployer::Image.new
    end

    def select_image_from_catalog
      
      selected_action = @main_interactor.select_action

      case selected_action.option
      when '<< Exit'
        puts "Byeee"
        return RegularDeployer::MenuResult.new(false)
      when 'Deploy an image'
        select_image_and_tag
        return RegularDeployer::MenuResult.new(true)
      end
    end
    
    def select_image_and_tag
      selected_image = @main_interactor.select_image
      return unless selected_image.valid?

      selected_tag = @main_interactor.select_tag(selected_image.option)
      return unless selected_tag.valid?

      final_selected_image = "#{selected_image.option}:#{selected_tag.option}"
      Helper::Logging.debug("Image to deploy: #{final_selected_image}")

      @deployer.run(final_selected_image)
    end
    
  end
end