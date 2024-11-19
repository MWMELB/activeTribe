class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: :create
  before_action :set_booking, only: :destroy
  def index
    # @bookings = current_user.bookings.includes(:activity)
    @bookings = policy_scope(Booking)
  end

  def create
    @booking = Booking.new(activity: @activity, user: current_user, status: :Pending)
    authorize @booking
    if @booking.save
      flash[:notice] = "Activity booked successfully!"
      redirect_to bookings_path
    else
      flash[:alert] = "You have already booked this activity."
      redirect_to activity_path(@activity)
    end
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    if @booking.destroy
      flash[:notice] = "Booking cancelled successfully."
    else
      flash[:alert] = "Failed to cancel the booking."
    end
    redirect_to bookings_path
  end

  def booking_requests
    @booking_requests = Booking.joins(:activity).where(activities: { user: current_user })
    @booking_requests.each do |booking_request|
      authorize booking_request, :owner?
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def set_booking

  end
end
