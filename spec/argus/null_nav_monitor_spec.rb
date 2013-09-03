require 'rspec/given'
require 'argus/null_nav_monitor'

describe Argus::NullNavMonitor do
  Given(:nav) { Argus::NullNavMonitor.new }

  context "when calling a regular method" do
    When(:result) { nav.start }
    Then { result.should_not have_raised }
  end

  context "when calling a regular method" do
    When(:result) { nav.callback { } }
    Then { result.should have_raised(Argus::NullNavMonitor::UsageError) }
  end

end
