class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :destroy]
  def index
    @groups = policy_scope(Group)
  end

  def show
  end

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    authorize @group
    if @group.save
      flash[:notice] = "Group created successfully!"
      redirect_to group_path(@group)
    else
      flash.now[:alert] = "There was an error creating the group. Please check the form for errors."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @group.destroy
      flash[:notice] = "Group was successfully deleted."
    else
      flash[:alert] = "Failed to delete the group."
    end
    redirect_to group_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :photo)
  end

  def set_group
    @group = Group.find(params[:id])
    authorize @group
  end
end
