require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def encode(email, password)
    ActionController::HttpAuthentication::Basic.encode_credentials(
      email,
      password
    )
  end

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
    post "/users", params: { name: "Mithrandir", password: "123456" }
    assert_response :created
    refute_empty response.body

    user = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Mithrandir", user[:name]
  end

  test "returns a bad request" do
    post "/users", params: { name: "name" }
    assert_response :bad_request
    refute_empty response.body

    data = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Invalid paramaters", data[:message]
    assert_equal ["Password can't be blank"], data[:errors]
  end

  test "returns not found message" do
    get "/users/fake/route"
    assert_response :not_found
    refute_empty response.body

    data = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Not found", data[:message]
  end

  test "returns unauthorized because user is not logged in" do
    get "/me", headers: { Authorization: encode("fake@email.com", "12345") }
    assert_response :unauthorized
    refute_empty response.body

    data = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Invalid credentials", data[:message]
  end

  test "returns forbidden because user has not access to this endpoint" do
    get "/users/private", headers: { Authorization: encode(users(:mary).email, "marydoe") }
    assert_response :forbidden
    refute_empty response.body

    data = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Not allowed", data[:message]
  end
end
