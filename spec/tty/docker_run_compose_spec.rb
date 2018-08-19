require 'spec_helper'
require 'tty-command'

describe 'tty client inspect' do
  let(:tty_docker_client)          { TTY::DockerRun.new }

  it 'extract compose' do
    result = tty_docker_client.extract_compose("label_alpine:3.6")
    puts result

  end

end