require 'spec_helper'

describe 'tty client login' do

  let(:tty_docker_run)  { TTY::DockerRun.new }
  
  context 'Success' do 
    let(:dbl_good_response) { double('CmdGoodResponse') }

    it 'Login success' do 
      allow(dbl_good_response).to receive(:success?).and_return(true)
      allow(dbl_good_response).to receive(:out).and_return(:empty)
      allow(dbl_good_response).to receive(:err).and_return(:empty)

      allow_any_instance_of(TTY::Command).to receive(:run).and_return(dbl_good_response)
      result = tty_docker_run.login
      expect(result.success?).to eql(true)
    end
  end

  context 'No success' do
    let(:double_error_result) { double('ExitError') }
    it 'fail to login cause, not reachable' do
      allow(double_error_result).to \
        receive(:exit_status).and_return('no host reachable')
      allow(double_error_result).to \
        receive(:out).and_return('no host')
      allow(double_error_result).to \
        receive(:err).and_return('not allowed to login')

      tty_exit_error = TTY::Command::ExitError.new('docker login', double_error_result)

      allow_any_instance_of(TTY::Command).to receive(:run).and_raise(tty_exit_error)

      result = tty_docker_run.login
      expect(result.success?).to eql(false)
      expect(result.err.include?('not allowed to login')).to eql(true)
    end
  end

end