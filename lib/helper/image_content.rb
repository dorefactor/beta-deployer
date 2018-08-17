require 'json'

module Helper
  class ImageContent
    
    def self.parse_inspect(content)
      parsed_content = JSON.parse(content)
      parsed_content.first['Config']['Labels'].nil? ? {} : parsed_content.first['Config']['Labels']
    end
    
  end
end