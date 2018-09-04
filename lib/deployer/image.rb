module Deployer
  class Image

    def initialize
      @tty_docker_run = TTY::DockerRun.new
    end

    def run(final_selected_image)
      ##Crete the workspace
      workspace_struct = Deployer::WorkspaceStruct.new(final_selected_image)
      
      Helper::Logging.info("Stopping and deleting possible container/images")
      @tty_docker_run.docker_compose_down(workspace_struct.docker_compose_path)
      @tty_docker_run.clean_image(final_selected_image)
      
      pull_image_action = @tty_docker_run.pull_from_registry(final_selected_image)
      return unless pull_image_action.success?
    
      Workspace::Folder.recreate(workspace_struct.base_folder)

      ##Get the file 
      Helper::Logging.info('Extracting info for docker-compose')
      extract_compose = @tty_docker_run.extract_compose(final_selected_image)
      return unless extract_compose.success?

      docker_compose_content = modify_docker_compose_image_name(extract_compose.out, final_selected_image)

      Workspace::Compose.save(workspace_struct.docker_compose_path, docker_compose_content)
      
      Helper::Logging.info("Running new docker-compose: #{workspace_struct.docker_compose_path}....")
      @tty_docker_run.docker_compose_up(workspace_struct.docker_compose_path)
      @tty_docker_run.docker_compose_ps(workspace_struct.docker_compose_path)
    end


    private

    def modify_docker_compose_image_name(content, final_selected_image)
      content.gsub!("{{image.name}}", Helper::Command.registry_image_name(final_selected_image))
    end    

  end
end