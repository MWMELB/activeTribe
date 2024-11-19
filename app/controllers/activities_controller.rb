class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    @activities = policy_scope(Activity)
  end

  def show
    authorize @activity
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
      redirect_to @activity
    else
      flash.now[:alert] = "There was an error creating the activity. Please check the form for errors."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @activity = Activity.find(params[:id])
    authorize @activity
    # redirect_to activities_path, alert: "You can't edit this activity" unless @activity.user == current_user
  end

  def update
    @activity = Activity.find(params[:id])
    authorize @activity
    # if @activity.user == current_user
      if @activity.update(activity_params)
        flash[:notice] = "Activity updated successfully!"
        redirect_to @activity
      else
        flash.now[:alert] = "There was an error updating the activity."
        render :edit, status: :unprocessable_entity
      end
    # else
      # redirect_to activities_path, alert: "You can't edit this activity"
    # end
  end

  def destroy
    authorize @activity
    # if @activity.user == current_user
      @activity.destroy
      flash[:notice] = "Activity was successfully deleted."
    # else
      # redirect_to root_path, status: :unprocessable_entity
    # end
    redirect_to activities_path
  end

  private

  def activity_params
    params.require(:activity).permit(:title, :description, :category, :start, :duration, :price, :location)
  end

  def set_activity
    @activity = Activity.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Activity not found."
    redirect_to activities_path
  end

  def activity_params
    params.require(:activity).permit(:title, :photo, :description, :location, :price, :start, :duration, :sport, :category, :capacity )
  end
end
