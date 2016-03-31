class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include Rails::API::Utils::Controllers::RenderConcern

  def render_404
    render_not_found "Not found"
  end

  def render_500
    some_undefined_variable
  end

  def current_user
    @current_user
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |email, password|
      @current_user = User.find_by(email: email)
      @current_user && @current_user.authenticate(password) || render_unauthorized
    end
  end

  def authorize
    (current_user && current_user.name == "Joe Doe") || render_forbidden
  end
end
