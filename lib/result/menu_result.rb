module RegularDeployer
  class MenuResult
    
    attr_reader :options
            
    def initialize(continue, options = [])
      @continue = continue
      @options = options
    end
    
    def continue?
      @continue
    end

  end
end