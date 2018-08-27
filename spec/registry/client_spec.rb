require 'spec_helper'

describe 'Registry client' do

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

  it 'Create new instances' do 
    allow(DockerRegistry2).to receive(:connect).and_return(docker_registry2_dummy)
    client = Registry::Client.new
    expect(client.login?).to eql(true)
    expect(client).not_to eql(nil)
  end

  it 'Perform a ping call' do
    allow(DockerRegistry2).to receive(:connect).and_return(docker_registry2_dummy)
    allow_any_instance_of(DockerRegistry2::Registry).to receive(:ping).and_return({})
    client = Registry::Client.new()
    ping_result = client.ping
    expect(ping_result).to be_instance_of(RegularDeployer::Result)
    expect(ping_result.success?).to eql(true)
    expect(ping_result.out).to eql({})
  end

  it 'Perform a client _catalog_v2 call' do
    allow(DockerRegistry2).to receive(:connect).and_return(docker_registry2_dummy)
    allow_any_instance_of(DockerRegistry2::Registry).to receive(:doget).and_return(good_response_v2_catalog)
    client = Registry::Client.new()
    _catalog_v2_result = client._catalog_v2
    expect(_catalog_v2_result.out).to be_instance_of(Hash)
    expect(_catalog_v2_result.out['repositories']).to be_instance_of(Array)
  end

  it 'Perform a client tag  for an image info call' do
    allow(DockerRegistry2).to receive(:connect).and_return(docker_registry2_dummy)
    allow_any_instance_of(DockerRegistry2::Registry).to receive(:tags).and_return(good_response_tag)
    client = Registry::Client.new()
    result = client.tags('demo1')
    expect(result.out).to be_instance_of(Hash)
    expect(result.out.has_key?('name')).to eql(true)
    expect(result.out.has_key?('tags')).to eql(true)
    expect(result.out['tags']).to be_instance_of(Array)
  end

end