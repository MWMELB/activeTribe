class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
  end

  private
  def set_activity

  end
end
