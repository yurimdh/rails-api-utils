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

  test "returns not_found when user ID doesn't exist" do
    get "/users/91392830"
    assert_response :not_found
    refute_empty response.body

    data = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Resource not found.", data[:message]
  end

  test "creates an user" do
    post "/users", params: { name: "Mithrandir", password: "123456" }
    assert_response :created
    refute_empty response.body

    user = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Mithrandir", user[:name]
  end

  test "returns a bad request when data is invalid" do
    post "/users", params: { name: "name" }
    assert_response :bad_request
    refute_empty response.body

    data = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Validation failed.", data[:message]
    assert_equal "password", data.dig(:errors, 0, :field)
    assert_equal "'password' can't be blank, 'password' is too short (minimum is 6 characters).", data.dig(:errors, 0, :message)
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

  test "doesn't return any content when a user is deleted" do
    post "/users", params: { name: "Mithrandir", password: "123456" }
    assert_response :created

    user = JSON.parse(response.body, symbolize_names: true)

    delete "/users/#{user[:id]}"

    assert_response :no_content
    assert_empty response.body
  end

  test "understands camelCase keys" do
    post "/users", params: { name: "Mithrandir", password: "123456" },
                   headers: { HTTP_X_KEY_FORMAT: "camelCase" }
    assert_response :created
    user = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Mithrandir", user[:name]
    assert_equal "Mithrandir", user[:userName]
  end

  test "returns an in valid parameter message when RailsParam validation fails" do
    post "/users", params: { password: "123456" }
    assert_response :bad_request
    refute_empty response.body

    data = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Invalid parameter.", data[:message]
    assert_equal "name", data.dig(:errors, 0, :field)
    assert_equal "'name' is required.", data.dig(:errors, 0, :message)
  end

  test "renders 500 error" do
    get "/error"
    assert_response :error
    refute_empty response.body

    data = JSON.parse(response.body, symbolize_names: true)
    assert_equal "Something went wrong.", data[:message]
  end
end
