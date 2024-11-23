class GroupCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def create
    @comment = @group.group_comments.build(comment_params)
    @comment.user = current_user # Associate the comment with the current user
    authorize @group, :comment?
    if @comment.save
      flash[:notice] = "Comment posted successfully."
      redirect_to group_path(@group)
    else
      flash[:alert] = "Failed to post comment."
      render 'groups/show'
    end
  end

  def destroy
    @comment = @group.group_comments.find(params[:id])
    Rails.logger.debug "Comment ID: #{params[:id]}, Group ID: #{@group.id}"
    authorize @comment, :destroy? # Assuming you have pundit authorization for comment actions
    if @comment.destroy
      flash[:notice] = "Comment deleted."
    else
      flash[:alert] = "Failed to delete comment."
    end

    redirect_to group_path(@group)
  end

  def show
    @group_comment = @group.group_comments.find(params[:id])
    authorize @group_comment, :show?
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def comment_params
    params.require(:group_comment).permit(:content) # Only allow content for comments
  end
end
