class Api::V1::ActivitiesController < ApplicationController
  before_filter :authenticate_and_authorize

  def index
    if params[:page]
      if nested_org_request?(params)
        @activities = Activity.organisation_activities(params[:organisation_id])
          .page(params[:page]).per_page(20)
      else
        @activities = Activity.includes(:user, :trackable).page(params[:page]).per_page(20)
      end
    else
      if nested_org_request?(params)
        @activities = Activity.organisation_activities(params[:organisation_id])
      else
        @activities = Activity.includes(:user, :trackable)
      end
    end

    @activities.order("created_at desc")
  end

end
