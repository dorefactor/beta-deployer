require 'spec_helper'
require 'tty-command'
require 'yaml'

describe 'tty client extract compose' do
  let(:tty_docker_client) { TTY::DockerRun.new }
  
  let(:good_compose_string_result) do
    <<-COMPOSE
    version: '3'
    services:
      web:
        image: {{image.name}}
      ports:
        - "{{service.ports}}"
    COMPOSE
  end

  let(:bad_compose_string_result) do
    <<-COMPOSE
    versión: 'a'
    service:
      web:
        image: {{image.name}}
      ports:
        - "{{service.ports}}"
    COMPOSE
  end


  context 'Success' do
    it 'extract compose' do
      dbl_command_response = double('DockerRunCatDockerCompose')
      
      allow(dbl_command_response).to \
        receive(:success?).and_return(true)
      allow(dbl_command_response).to \
        receive(:out).and_return(good_compose_string_result)
      allow(dbl_command_response).to \
        receive(:err).and_return(:empty)
      
      allow_any_instance_of(TTY::Command).to \
        receive(:run).and_return(dbl_command_response)
      
        result = tty_docker_client.extract_compose('label_alpine:3.6')
      expect(result.success?).to eql(true)
    end
  end

  context 'No success' do
    it 'extract compose' do
      dbl_command_response = double('DockerRunCatDockerCompose')

      allow(dbl_command_response).to \
        receive(:success?).and_return(true)
      allow(dbl_command_response).to \
        receive(:out).and_return(bad_compose_string_result)
        allow(dbl_command_response).to \
        receive(:err).and_return(:empty)
      
      allow_any_instance_of(TTY::Command).to \
        receive(:run).and_return(dbl_command_response)
      
      result = tty_docker_client.extract_compose('label_alpine:3.6')
      expect(result.success?).to eql(false)
      expect(result.err.include?('The content for compose is invalid')).to eql(true)
    end

    it 'raise error' do
      dbl_exit_error = double('ExitError')
      
      allow(dbl_exit_error).to \
        receive(:exit_status).and_return('1')
      allow(dbl_exit_error).to \
        receive(:out).and_return('Nothing written')
      allow(dbl_exit_error).to \
        receive(:err).and_return('can\'t open \'/opt/dorefactor/docker-compose.yml1\': No such file or directory')
      
      tty_error_exit = TTY::Command::ExitError.new('docker run extract_compose', dbl_exit_error)
      
      allow_any_instance_of(TTY::Command).to \
        receive(:run).and_raise(tty_error_exit)

      result = tty_docker_client.extract_compose('label_alpine:3.6')
    end
  end
end