class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: :create
  before_action :set_booking, only: :destroy
  def index
    # @bookings = current_user.bookings.includes(:activity)
    @bookings = policy_scope(Booking)
  end

  def create
    # @activity = Activity.find(params[:activity_id])
    # @booking = @activity.bookings.build(user: current_user, status: :Pending)
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

  def destroy
    authorize @booking
    if @booking.destroy
      flash[:notice] = "Booking cancelled successfully."
    else
      flash[:alert] = "Failed to cancel the booking."
    end
    redirect_to bookings_path
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
