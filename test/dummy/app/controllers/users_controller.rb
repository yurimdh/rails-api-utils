class UsersController < ApplicationController
  before_action :authenticate, only: [:me, :private]
  before_action :authorize, only: [:private]

  def index
    render_success User.all, serializer: UserSerializer
  end

  def show
    user = User.find(params[:id])
    render_success user, serializer: UserSerializer
  end

  def me
    render_success current_user, serializer: UserSerializer
  end

  def create
    param! :name, String
    param! :password, String

    user = User.create(name: params[:name],
                       password: params[:password])
    if user.valid?
      render_created user, serializer: UserSerializer
    else
      render_error "Invalid paramaters", errors: user.errors
    end
  end

  def private
    user = { name: "Joe Doe" }
    render_success user
  end
end
