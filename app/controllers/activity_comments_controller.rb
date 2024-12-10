class ActivityCommentsController < ApplicationController
  before_action :set_activity, :set_post

  def new
    @comment = GroupComment.new
  end

  def create
    @comment = @post.activity_comments.new(comment_params)
    @comment.user = current_user
    authorize @comment

    if @comment.save
      redirect_to activity_activity_post_path(@activity, @post)
    else
      flash[:alert] = "Failed to post post."
      render 'activities/show'
    end
  end

  def destroy
    @comment = ActivityComment.find(params[:id])
    # raise
    authorize @comment
    if @comment.destroy
      flash[:notice] = "comment deleted."
    else
      flash[:alert] = "Failed to delete comment."
    end

    redirect_to activity_activity_post_path(@post)
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def set_post
    @post = ActivityPost.find(params[:activity_post_id])
  end

  def comment_params
    params.require(:activity_comment).permit(:content)
  end
end
