require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "returns all users" do
    get "/users"
    assert_response :success
    refute_empty response.body

    users = JSON.parse(response.body, symbolize_names: true)
    assert_equal 2, users.size
  end

  test "returns 1 user" do
    get "/users/#{users(:joe).id}"
    assert_response :success
    refute_empty response.body

    user = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Joe Doe", user[:name]
  end
end
