require "simplecov"
SimpleCov.start "rails"

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "factory_bot_rails"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    include FactoryBot::Syntax::Methods

    FactoryBot.rewind_sequences

    def turbo_stream_action?(action, target = nil)
      assert_select "turbo-stream[action='#{action}']#{target ? "[target='#{target}']" : ""}"
    end

    def assert_turbo_stream(action:, target: nil)
      assert_equal "text/vnd.turbo-stream.html", response.content_type
      turbo_stream_action?(action, target)
    end
  end
end
