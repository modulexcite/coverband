require File.expand_path('../rails_test_helper', File.dirname(__FILE__))
require 'rails'

class RailsRakeFullStackTest < Minitest::Test

  test 'rake tasks shows coverage properly within eager_loading' do
    system("COVERBAND_CONFIG=./test/rails#{Rails::VERSION::MAJOR}_dummy/config/coverband.rb bundle exec rake -f test/rails#{Rails::VERSION::MAJOR}_dummy/Rakefile middleware")
    store.instance_variable_set(:@redis_namespace, 'coverband_test')
    store.type = :eager_loading
    pundit_file = store.coverage.keys.grep(/pundit.rb/).first
    refute_nil pundit_file
    pundit_coverage = store.coverage[pundit_file]
    refute_nil pundit_coverage
    assert_includes pundit_coverage['data'], 1

    store.type = nil
    pundit_coverage = store.coverage[pundit_file]
    assert_nil pundit_coverage
  end
end
