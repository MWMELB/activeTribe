class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    @activities = policy_scope(Activity)
  end

  def show
    @marker = {
      lat: @activity.latitude,
      lng: @activity.longitude
    }
  end

  def new
    @activity = Activity.new
    authorize @activity
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.user = current_user
    authorize @activity
    if @activity.save
      flash[:notice] = "Activity created successfully!"
      redirect_to activity_path(@activity)
    else
      flash.now[:alert] = "There was an error creating the activity. Please check the form for errors."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update(activity_params)
      flash[:notice] = "Activity updated successfully!"
      redirect_to @activity
    else
      flash.now[:alert] = "There was an error updating the activity."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @activity.destroy
      flash[:notice] = "Activity was successfully deleted."
    else
      flash[:alert] = "Failed to delete the activity."
    end
    redirect_to activities_path
  end

  private

  def activity_params
    params.require(:activity).permit(:title, :description, :category, :start, :duration, :price, :location)
  end

  def set_activity
    @activity = Activity.find(params[:id])
    authorize @activity
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Activity not found."
    redirect_to activities_path
  end

  def activity_params
    params.require(:activity).permit(:title, :photo, :description, :location, :price, :start, :duration, :sport, :category, :capacity )
  end
end
