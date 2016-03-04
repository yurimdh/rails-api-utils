class UsersController < ApplicationController
  def index
    render_success User.all, serializer: UserSerializer
  end

  def show
    user = User.find(params[:id])
    render_success user, serializer: UserSerializer
  end
end
