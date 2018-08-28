module Menu
  class Main

    def initialize
      @options = [
        'Deploy an image',
        '<< Exit'
      ]
      
    end

    def select_options
      print_header
      selected_option = Menu.prompt.select('Choose an image', @options )

      case selected_option
      when '<< Exit'
        puts "Byeee"
        return RegularDeployer::MenuResult.new(false)
      when 'Deploy an image'
        return RegularDeployer::MenuResult.new(true)
      end
    end
     
    private
    
    def print_header
      puts %{
        Welcome to RegularDeployer version 0.1}
    end
  end
end