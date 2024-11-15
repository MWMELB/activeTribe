class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  def index
    @activities = Activity.all
  end

  def show
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = current_user.activities.build(activity_params)
    @activity.user = current_user
    if @activity.save
      flash[:notice] = "Activity created successfully!"
      redirect_to @activity
    else
      flash.now[:alert] = "There was an error creating the activity."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @activity.update(activity_params)
      redirect_to @activity, notice: "Activity updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    if current_user.activity_owner?
      @activity.destroy
      redirect_to activities_path, notice: "Activity deleted successfully."
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:title, :description, :category, :start, :duration, :price, :location, :sport)
  end

  def set_activity
    @activity = Activity.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Activity not found."
    redirect_to activities_path
  end
end
