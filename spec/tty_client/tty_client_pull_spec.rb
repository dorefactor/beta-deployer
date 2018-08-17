require 'spec_helper'

describe 'tty client pull' do
  let(:tty_client) { Registry::TTYClient.new }
  let(:good_response) do 
    { success: true }
  end
  let(:dbl_cmd_pull_result) { double('cmd_pull') }

  context 'Success' do 
    it 'pull an image' do
      allow_any_instance_of(Registry::TTYClient).to receive(:login).and_return(good_response)
      allow(dbl_cmd_pull_result).to receive(:success?).and_return(true)
      allow_any_instance_of(TTY::Command).to receive(:run).and_return(dbl_cmd_pull_result)
      
      result = tty_client.pull("#{RegistryAuth.configuration.registry}/postgres:9.5")
      expect(result[:success]).to eql(true)
    end
  end

  context 'No success' do
    it 'fail to pull an image that does not exists' do
      allow_any_instance_of(Registry::TTYClient).to receive(:login).and_return(good_response)
      allow(dbl_cmd_pull_result).to receive(:exit_status).and_return('the image does not exists')
      allow(dbl_cmd_pull_result).to receive(:out).and_return('not image')
      allow(dbl_cmd_pull_result).to receive(:err).and_return('unable to find the image')

      tty_exit_error = TTY::Command::ExitError.new('docker pull', dbl_cmd_pull_result)
      allow_any_instance_of(TTY::Command).to receive(:run).and_raise(tty_exit_error)
      
      result = tty_client.pull('noimage:bro')
      expect(result[:success]).to eql(false)
      expect(result[:message].include?('stderr: unable to find the image')).to eql(true)
    end
  end
end