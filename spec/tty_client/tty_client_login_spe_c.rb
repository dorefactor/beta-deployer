require 'spec_helper'

describe 'tty client' do

  let(:tty_client) { Registry::TTYClient.new }
  
  let(:cmd_response) do
    Struct.new(:success) do
      def success?
        success
      end
    end
  end
  let(:cmd_good_response) { cmd_response.new(true) }

  let(:tty_client_good_response) do
    {
      success: true
    }
  end
  
  let(:inspect_image_good) do
    Struct.new(:success) {
      def success?
        success
      end

      def out
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
    }
  end


  context 'Success' do 
    it 'Login success' do 
      allow_any_instance_of(TTY::Command).to receive(:run).and_return(cmd_good_response)
      result = tty_client.login
      expect(result[:success]).to eql(true)
    end

    it 'pull an image' do
      allow_any_instance_of(Registry::TTYClient).to receive(:login).and_return(tty_client_good_response)
      allow_any_instance_of(TTY::Command).to receive(:run).and_return(cmd_good_response)
      result = tty_client.pull('postgres:9.5')
      expect(result[:success]).to eql(true)
    end

    it 'inspect an image' do
      good_inspect = inspect_image_good.new(true)
      allow_any_instance_of(TTY::Command).to receive(:run).and_return(good_inspect)
      result = tty_client.inspect_image("#{RegistryAuth.configuration.registry}/postgres:9.5")
    end
  end

  context 'No success' do
    let(:bad_cmd_registry_auth_not_reachable) do
      %{
        docker login https://IdoNotExists \
        -u IDoNotExists --password-stdin
      }
    end

    it 'fail to login cause, not reachable' do
      allow(Helper::Command).to receive(:authenticate).and_return(bad_cmd_registry_auth_not_reachable)
      result = tty_client.login
      expect(result[:success]).to eql(false)
      expect(result[:message].include?('stderr: Error response from daemon')).to eql(true)
    end

    it 'fail to pull an image that does not exists' do
      allow_any_instance_of(Registry::TTYClient).to receive(:login).and_return(tty_client_good_response)
      result = tty_client.pull('noimagebro')
      expect(result[:success]).to eql(false)
      expect(result[:message].include?('stderr: Error response from daemon: manifest')).to eql(true)
    end

    it 'fail to pull an image with empty string: invalid reference format' do
      allow_any_instance_of(Registry::TTYClient).to receive(:login).and_return(tty_client_good_response)
      result = tty_client.pull('')
      expect(result[:success]).to eql(false)
      expect(result[:message].include?('stderr: invalid reference format')).to eql(true)
    end
  end

end