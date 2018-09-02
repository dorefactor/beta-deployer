
module Workspace
  class Compose

    def self.save(path, content)
      File.open(path, 'w+') do |file|
        file.puts content
      end
    end

  end
end