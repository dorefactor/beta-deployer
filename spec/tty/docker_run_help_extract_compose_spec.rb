require 'spec_helper'
require 'yaml'
describe 'tty client inspect' do
  let(:tty_docker_run)      { TTY::DockerRun.new }
  let(:dbl_inspect_result)  { double('InspectResult') }
  
  let(:image_name)          { 'nginx:9.5' }
  let(:compose_string_result) do
    <<-COMPOSE
    version: '3'
    services:
      web:
        image: {{image.name}}
      ports:
        - "{{service.ports}}"
    COMPOSE
  end

  let(:labels) do
    {
      'service.ports' => '80'
    }
  end
    
  context 'Success' do 
    it 'extract compose' do 
      #image name
      
      compose_string_result.gsub!("{{image.name}}", image_name)

      ##labels
      labels.each do |placeholder, value|
        compose_string_result.gsub!("{{#{placeholder}}}", value)
      end
      puts compose_string_result

    end
    
  end
end