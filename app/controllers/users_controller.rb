class UsersController < ApplicationController
  before_action :authenticate_user!

  def show

    @user = User.find_by(username: params[:username])
    authorize User
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :photo)
  end
end
