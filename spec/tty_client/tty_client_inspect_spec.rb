require 'spec_helper'

describe 'tty client inspect' do
  let(:tty_client)          { Registry::TTYClient.new }
  let(:dbl_inspect_result)  { double('InspectResult') }
  let(:json_result_out) do
    %{[
      {
        "Id": "sha256:6635927541e86f8351315dc5fd9b7557de71f5b61b5542c1e031bbbc71a55a76",
        "RepoTags": [
            "somehost/awesomeImage:9.5"
        ],
        "Config": {
          "Labels": {
            "service.host": "https://service"
          }
        }
      }
    ]}
  end

  context 'Success' do 

    it 'inspect an image' do
      allow(dbl_inspect_result).to receive(:success?).and_return(true)
      allow(dbl_inspect_result).to receive(:out).and_return(json_result_out)
      allow_any_instance_of(TTY::Command).to receive(:run).and_return(dbl_inspect_result)

      result = tty_client.inspect("#{RegistryAuth.configuration.registry}/postgres:9.5")

      expect(result[:success]).to eql(true)
      expect(result[:labels].include?('service.host')).to eql(true)
    end
  end

  context 'No success' do
    it 'receives an error' do
      allow(dbl_inspect_result).to receive(:exit_status).and_return('An error ocurred inspecting the image')
      allow(dbl_inspect_result).to receive(:out).and_return('Nothing to inspect')
      allow(dbl_inspect_result).to receive(:err).and_return('The image does not exists')
      
      tty_exit_error = TTY::Command::ExitError.new('docker inspect', dbl_inspect_result)
      allow_any_instance_of(TTY::Command).to receive(:run).and_raise(tty_exit_error)
      
      result = tty_client.inspect("#{RegistryAuth.configuration.registry}/noimage:bro")
      expect(result[:success]).to eql(false)
      expect(result[:message].include?('stderr: The image does not exists')).to eql(true)
    end
  end

end