require 'spec_helper'

describe 'Registry client' do

  let(:docker_registry2_dummy) {DockerRegistry2::Registry.new('uri',{})}

  let(:good_response_v2_catalog) do
    {
      'repositories': ['demo1', 'demo2']
    }
  end

  let(:good_response_tag) do
    {
      'name' => 'demo1',
      'tags'  => ['1.1']
    }
  end

  # {"name"=>"postgres", "tags"=>["9.5"]}

  it 'Create new instances' do 
    allow(DockerRegistry2).to receive(:connect).and_return(docker_registry2_dummy)
    client = Registry::Client.new
    expect(client).not_to eql(nil)
  end

  it 'Perform a ping call' do
    allow(DockerRegistry2).to receive(:connect).and_return(docker_registry2_dummy)
    allow_any_instance_of(DockerRegistry2::Registry).to receive(:ping).and_return({})
    client = Registry::Client.new()
    expect(client.ping).not_to eql(nil)
  end

  it 'Perform a client _catalog_v2 call' do
    allow(DockerRegistry2).to receive(:connect).and_return(docker_registry2_dummy)
    allow_any_instance_of(DockerRegistry2::Registry).to receive(:doget).and_return(good_response_v2_catalog)
    client = Registry::Client.new()
    expect(client._catalog_v2).to be_instance_of(Hash)
    expect(client._catalog_v2[:repositories]).to be_instance_of(Array)
  end


  it 'Perform a client tag  for an image info call' do
    allow(DockerRegistry2).to receive(:connect).and_return(docker_registry2_dummy)
    allow_any_instance_of(DockerRegistry2::Registry).to receive(:tags).and_return(good_response_tag)
    client = Registry::Client.new()
    result = client.tags('demo1')
    expect(result).to be_instance_of(Hash)
    expect(result.has_key?('name')).to eql(true)
    expect(result.has_key?('tags')).to eql(true)
    expect(result['tags']).to be_instance_of(Array)
  end

end