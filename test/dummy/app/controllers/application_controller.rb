class ApplicationController < ActionController::API
  include Rails::API::Utils::Controllers::RenderConcern

  def render_404
    render_not_found "Not found"
  end
end
