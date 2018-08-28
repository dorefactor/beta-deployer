require 'spec_helper'

describe 'Step select image from menu' do
  
  context 'happy path' do 
    let(:docker_registry2_dummy) { DockerRegistry2::Registry.new('uri',{}) }
    
    let(:good_response_v2_catalog) do
      <<-JSON
        { 
          "repositories": ["demo1", "demo2"] 
        }
      JSON
    end
  
    let(:good_response_tag) do
      {
        'name' => 'demo1',
        'tags'  => ['1.1']
      }
    end
    
    it 'connect to the registry' do
      allow(DockerRegistry2).to receive(:connect).and_return(docker_registry2_dummy)
      allow_any_instance_of(DockerRegistry2::Registry).to receive(:doget).and_return(good_response_v2_catalog)
      allow_any_instance_of(DockerRegistry2::Registry).to receive(:tags).and_return(good_response_tag)
      
      client = Registry::Client.new
      expect(client.login?).to eql(true)
        
      select_image = Menu::Options::SelectImage.new(client)
      puts select_image.get_images.options.inspect
      
    end
  end
end