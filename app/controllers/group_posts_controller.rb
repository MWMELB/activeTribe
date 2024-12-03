class GroupPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def show
    @post = GroupPost.find(params[:id])
    @comment = GroupComment.new
    authorize @post
  end

  def create
    @post = @group.group_posts.build(post_params)
    @post.user = current_user # Associate the post with the current user
    authorize @post
    if @post.save
      flash[:notice] = "post posted successfully."
      redirect_to group_path(@group)
    else
      flash[:alert] = "Failed to post post."
      render 'groups/show'
    end
  end

  def destroy
    @post = @group.group_posts.find(params[:id])
    authorize @post
    if @post.destroy
      flash[:notice] = "post deleted."
    else
      flash[:alert] = "Failed to delete post."
    end

    redirect_to group_path(@group)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def post_params
    params.require(:group_post).permit(:content) # Only allow content for posts
  end
end
