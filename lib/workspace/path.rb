module Workspace
  class Path
    def self.relative(path)
      "#{Application.properties.workspace_path}/#{path}"
    end
  end
end