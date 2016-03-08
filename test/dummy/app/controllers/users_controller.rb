class UsersController < ApplicationController
  def index
    render_success User.all, serializer: UserSerializer
  end

  def show
    user = User.find(params[:id])
    render_success user, serializer: UserSerializer
  end

  def create
    param! :name, String

    user = User.create(name: params[:name])
    if user.valid?
      render_created user, serializer: UserSerializer
    else
      render_error "Invalid paramaters", errors: user.errors
    end
  end
end
