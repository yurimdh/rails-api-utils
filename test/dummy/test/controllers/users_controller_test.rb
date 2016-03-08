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

  test "creates an user" do
    post "/users", params: { name: "Mithrandir" }
    assert_response :created
    refute_empty response.body

    user = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Mithrandir", user[:name]
  end

  test "returns a bad request" do
    post "/users", params: { name: "" }
    assert_response :bad_request
    refute_empty response.body

    data = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Invalid paramaters", data[:message]
    assert_equal ["Name can't be blank"], data[:errors]
  end
end
