class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(username: params[:username])
    authorize User
  end
end
