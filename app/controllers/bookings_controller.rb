class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @activity = Activity.find(params[:activity_id])
    @booking = @activity.bookings.build(user: current_user, status: :Pending)

    if @booking.save
      flash[:notice] = "Activity booked successfully!"
      redirect_to bookings_path
    else
      flash[:alert] = "You have already booked this activity."
      redirect_to activity_path(@activity)
    end
  end

  def index
    @bookings = current_user.bookings.includes(:activity)
  end

  def destroy
    @booking = Booking.find(params[:id])
    if @booking.destroy
      flash[:notice] = "Booking cancelled successfully."
    else
      flash[:alert] = "Failed to cancel the booking."
    end
    redirect_to bookings_path
  end
end
