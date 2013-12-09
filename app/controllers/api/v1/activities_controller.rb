class Api::V1::ActivitiesController < ApplicationController
  before_filter :authenticate_and_authorize

  def index
    if nested_org_request?(params) 
      @activities = Activity.trackable_id_eq(params[:organisation_id])
    else
      @activities = Activity.all
    end

    @activities.order("created_at desc")
  end

end
