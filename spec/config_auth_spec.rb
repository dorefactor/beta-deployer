require 'spec_helper'

describe 'Configuration Auth' do
  it 'Setting default values' do
    expect(RegistryAuth.configuration.host).not_to eql(nil)
    expect(RegistryAuth.configuration.user).not_to eql(nil)
    expect(RegistryAuth.configuration.password).not_to eql(nil)
  end 
end