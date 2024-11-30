class GroupCommentsController < ApplicationController
  before_action :set_group, :set_post

  def new
    @comment = GroupComment.new
  end

  def create
    @comment = @post.group_comments.new(comment_params)
    @comment.user = current_user
    authorize @comment

    if @comment.save
      redirect_to group_group_post_path(@group, @post)
    else
      flash[:alert] = "Failed to post post."
      render 'groups/show'
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_post
    @post = GroupPost.find(params[:group_post_id])
  end

  def comment_params
    params.require(:group_comment).permit(:content)
  end
end
