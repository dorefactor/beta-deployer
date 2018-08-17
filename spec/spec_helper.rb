
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'init'

$LOAD_PATH.unshift(File.expand_path('../support', __FILE__))

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.formatter = :documentation
  config.fail_fast = true
  # config.filter_run :focus => false
end
