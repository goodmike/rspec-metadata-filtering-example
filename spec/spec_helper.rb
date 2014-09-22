# The module is included in this file for simplicity
module ControllerMacros
    def puts_proof_of_extensions_by_proc
        before do
            puts ">>> Extended with ControllerMacros by PROC match"
        end
    end
    def prove_by_letting_value
        let(:proof_value) { true }
    end
    def proc_extended_helper_method
        return true
    end
end

RSpec.configure do |config|

    # Extend an example group with a helper module iff the group describes a controller
    action_controller_extension_filter = {
      described_class: -> described { described < ActionController::Base }
    }

    config.extend ControllerMacros, action_controller_extension_filter

    # Only call helper module's methods if metadata flag is also present
    action_controller_activation_filter = {
      described_class: -> described { described < ActionController::Base },
      prove_it: "proc"
    }

    config.before(:all, action_controller_activation_filter) do
        self.class.puts_proof_of_extensions_by_proc
        self.class.prove_by_letting_value
    end

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = :expect
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true

  end
end
