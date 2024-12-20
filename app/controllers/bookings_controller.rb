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
    @pending_requests = Booking.joins(:activity).where(activities: { user: current_user }).where(status: :Pending)
    @accepted_requests = Booking.joins(:activity).where(activities: { user: current_user }).where(status: :Accepted)
    @declined_requests = Booking.joins(:activity).where(activities: { user: current_user }).where(status: :Declined)

    authorize Booking, :booking_requests?
  end

  def accept
    @booking = Booking.find(params[:id])
    authorize @booking
    if @booking.update(status: 1)
      redirect_to activity_path(@booking.activity), notice: "Booking accepted successfully."
    else
      redirect_to activity_path(@booking.activity), alert: "Failed to accept the booking."
    end
  end

  def decline
    @booking = Booking.find(params[:id])
    authorize @booking
    if @booking.update(status: 2)
      redirect_to activity_path(@booking.activity), notice: "Booking declined successfully."
    else
      redirect_to activity_path(@booking.activity), alert: "Failed to decline the booking."
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_booking

  end

  def booking_params
    params.require(:booking).permit(:status)
  end
end
