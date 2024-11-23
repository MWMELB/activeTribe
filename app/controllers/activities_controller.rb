class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    @activities = policy_scope(Activity)
    Rails.logger.debug "Search term: #{params[:search]}"
    if params[:search].present?
      @activities = @activities.where('title ILIKE ?', "%#{params[:search]}%")
    end
  end

  def my_activities
    @activities = Activity.where( user: current_user )
    authorize Activity
  end

  def show
    @marker = {
      lat: @activity.latitude,
      lng: @activity.longitude
    }
    @pending_requests = Booking.joins(:activity).where(activities: { user: current_user }).where(status: :Pending)
    @accepted_requests = Booking.joins(:activity).where(activities: { user: current_user }).where(status: :Accepted)
    @declined_requests = Booking.joins(:activity).where(activities: { user: current_user }).where(status: :Declined)

    authorize Booking, :booking_requests?
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
