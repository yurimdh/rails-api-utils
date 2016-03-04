require 'test_helper'

class Rails::API::Utils::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Rails::API::Utils
  end
end
