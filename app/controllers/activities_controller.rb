class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    @activities = policy_scope(Activity)

    Rails.logger.debug "Search term: #{params[:search]}"

    # Filter by search keyword
    if params[:search].present?
      @activities = @activities.where('title ILIKE ? OR description ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    end

    # Filter by date
        if params[:date].present?
          if params[:date] == Date.today.to_s
            @activities = @activities.where(start: Date.today.beginning_of_day..Date.today.end_of_day)
          elsif params[:date] == Date.tomorrow.to_s
            @activities = @activities.where(start: Date.tomorrow.beginning_of_day..Date.tomorrow.end_of_day)
          elsif params[:custom_date].present?
            @activities = @activities.where(start: params[:custom_date].to_date.beginning_of_day..params[:custom_date].to_date.end_of_day)
          end
        end


    # Filter by activity type
    if params[:category].present?
      if params[:category] == 'other'
        predefined_categories = ['basketball', 'tennis', 'hike', 'running', 'pickleball', 'surfing', 'yoga'] # Add more categories as needed
        @activities = @activities.where.not(category: predefined_categories)
      else
        @activities = @activities.where(category: params[:category])
      end
    end


    # Filter by price (free/paid)
    if params[:price].present?
      @activities = @activities.where(price: params[:price] == 'free' ? 0 : 1..Float::INFINITY)
    end

    # Sort by
    if params[:sort_by].present?
      @activities = @activities.order(params[:sort_by])
    end

    # Filter by location
    if params[:location].present?
      @activities = @activities.near(params[:location], 50) # 50 km radius
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
    @user_booking = current_user.bookings.find_by(activity: @activity)
    @booking = Booking.new(user: current_user, activity: @activity, status: :Pending)
    @pending_requests = Booking.where(activity: @activity, status: :Pending)
    @accepted_requests = Booking.where(activity: @activity, status: :Accepted)
    @declined_requests = Booking.where(activity: @activity, status: :Declined)

    authorize Booking, :booking_requests?
  end

  def new
    @activity = Activity.new
    authorize @activity
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.user = current_user
    @booking = Booking.create(activity: @activity, user: current_user)

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
    params.require(:activity).permit(:title, :photo, :description, :location, :price, :start, :duration, :sport, :category, :capacity, :level )
  end
end
