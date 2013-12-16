SPEC_ROOT = File.dirname(__FILE__)
$: << File.join(SPEC_ROOT, "..")
Dir[SPEC_ROOT + "spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.order = "random"
end