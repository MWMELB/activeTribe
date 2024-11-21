class GroupUsersController < ApplicationController

  def create
    @group = Group.find(params[:id])
    @group_user = GroupUser.new(group: @group, user: current_user)
    authorize @group_user
    if @group_user.save
      flash[:notice] = "Joined group successfully!"
      redirect_to groups_path
    else
      flash[:alert] = "Error"
      redirect_to group_path(@group)
    end
  end

end
