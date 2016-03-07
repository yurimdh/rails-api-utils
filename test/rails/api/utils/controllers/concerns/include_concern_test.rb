require "test_helper"

class DummyController < ActionController::API
  include Rails::API::Utils::Controllers::IncludeConcern
end

class DummyControllerTest < ActiveSupport::TestCase
  setup do
    @controller = DummyController.new
  end

  def stub_controller(method, value)
    @controller.stubs(method).returns(value)
  end

  test "is accepted with one include" do
    stub_controller(:params, include: "fake")
    @controller.include!(:fake, :real)

    assert_equal [:fake], @controller.includes
  end

  test "is accepted with several includes" do
    stub_controller(:params, include: "fake,real")
    @controller.include!(:fake, :real)
    assert_equal [:fake, :real], @controller.includes
  end

  test "is nil with no accepted include" do
    stub_controller(:params, include: "fake")
    assert_nil @controller.includes
  end

  test "is nil with no include" do
    stub_controller(:params, {})
    assert_nil @controller.includes
  end

  test "return an error with unkown include" do
    stub_controller(:params, include: "fake,valid")
    assert_raises RailsParam::Param::InvalidParameterError do
      @controller.include!(:fake, :real)
    end
  end
end
