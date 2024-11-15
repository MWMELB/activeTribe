class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ show ]
  def index
    @activities = Activity.all
  end

  def show
    @marker = {
      lat: @activity.latitude,
      lng: @activity.longitude
    }
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.user = current_user
    # raise
    if @activity.save!
      redirect_to activity_path(@activity)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:title, :photo, :description, :location, :price, :start, :duration, :sport)
  end
end
