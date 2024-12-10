class ActivityPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity

  def show
    @post = ActivityPost.find(params[:id])
    @comment = ActivityComment.new
    authorize @post
  end

  def create
    @post = @activity.activity_posts.build(post_params)
    @post.user = current_user # Associate the post with the current user
    authorize @post
    if @post.save
      flash[:notice] = "post posted successfully."
      redirect_to activity_path(@activity)
    else
      flash[:alert] = "Failed to post post."
      render 'activities/show'
    end
  end

  def destroy
    @post = @activity.activity_posts.find(params[:id])
    authorize @post
    if @post.destroy
      flash[:notice] = "post deleted."
    else
      flash[:alert] = "Failed to delete post."
    end

    redirect_to activity_path(@activity)
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def post_params
    params.require(:activity_post).permit(:content) # Only allow content for posts
  end
end
