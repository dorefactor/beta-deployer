module RegularDeployer
  class SelectedOptionResult
    
    attr_reader :option
            
    def initialize(option)
      @valid = option != '<< Back'
      @option = option
    end
    
    def valid?
      @valid
    end

  end
end