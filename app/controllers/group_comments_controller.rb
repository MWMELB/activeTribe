class GroupCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id]) # Find the group to which the comment belongs
    authorize @group, :comment?

    @comment = @group.group_comments.build(comment_params)
    @comment.user = current_user # Associate the comment with the current user

    if @comment.save
      flash[:notice] = "Comment posted successfully."
      redirect_to group_path(@group)
    else
      flash[:alert] = "Failed to post comment."
      render 'groups/show'
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    @comment = @group.group_comments.find(params[:id])
    authorize @comment, :destroy? # Assuming you have pundit authorization for comment actions

    if @comment.destroy
      flash[:notice] = "Comment deleted."
    else
      flash[:alert] = "Failed to delete comment."
    end

    redirect_to group_path(@group)
  end

  private

  def comment_params
    params.require(:group_comment).permit(:content) # Only allow content for comments
  end
end
