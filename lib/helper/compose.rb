module Helper
  class Compose
    def self.validate(compose_content)
      root_validation = LAMBDA_VALIDATE_ROOT.call(compose_content)
      root_validation
    end

    LAMBDA_VALIDATE_ROOT = ->(root) do
      root.keys.include?('version') \
        && root.keys.include?('services') \
        && !root['version'].match(/\A(\d)+(\.(\d)+){0,2}\z/).nil? 
    end
  end
end