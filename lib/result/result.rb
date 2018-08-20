module RegularDeployer
  class Result
    
    attr_reader :out
    attr_reader :err

    def self.create_error(err)
      RegularDeployer::Result.new(false, :empty, err)
    end

    def self.create_successful(out = :empty, err = :empty)
      RegularDeployer::Result.new(true, out, err)
    end
    
    def initialize(success, out, err)
      @success  = success
      @out      = out
      @err      = err
    end
    
    def success?
      @success
    end

  end
end