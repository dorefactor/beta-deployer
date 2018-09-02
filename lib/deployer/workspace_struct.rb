module Deployer
  class WorkspaceStruct

    attr_reader :base_folder
    attr_reader :docker_compose_path

    def initialize(final_selected_image)
      @base_folder          = build_base_folder(final_selected_image)
      @docker_compose_path  = "#{@base_folder}/docker-compose.yml"
    end

    private

    def build_base_folder(final_selected_image)
      "#{Application.properties.workspace_path}/#{final_selected_image.gsub(':','__')}"
    end
    
  end
end