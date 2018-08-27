require 'spec_helper'

module MenuFlow
  class SelectImage
    def initialize(registy_client)
      @registy_client = registy_client
    end

    def image_options
      result_catalog = @registy_client._catalog_v2
      build_option_response(result_catalog, 'repositories')
    end

    def tag_options(image)
      result_tag = @registy_client.tags(image)
      build_option_response(result_catalog, 'tags')
    end

    private

    def build_option_response(result, source)
      choices = result.success? ? result.out[source]  : Array.new
      choices << "<< Back"
      RegularDeployer::Result.new(result.success?, choices, :empty)
    end
  end
end

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
        
      select_image = MenuFlow::SelectImage.new(client)
      puts select_image.image_options.out.inspect

      # ##get the images
      # _catalog_v2_result = client._catalog_v2
      # expect(_catalog_v2_result.success?).to eql(true)
      # expect(_catalog_v2_result.out).to be_instance_of(Hash)
      # expect(_catalog_v2_result.out['repositories']).to be_instance_of(Array)
      
      # ##get the tag
      # result = client.tags('demo1')
      # expect(result.out).to be_instance_of(Hash)
      # expect(result.out.has_key?('name')).to eql(true)
      # expect(result.out.has_key?('tags')).to eql(true)
      # expect(result.out['tags']).to be_instance_of(Array)




    end
  end
end