class Api::V1::ActivitiesController < ApplicationController
  before_filter :authenticate_and_authorize

  def index
    @activities = Activity.order("created_at desc")
  end

end
