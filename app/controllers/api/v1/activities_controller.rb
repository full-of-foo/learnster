class Api::V1::ActivitiesController < ApplicationController
  after_filter only: [:index] { paginate(:activities) }
  before_filter :authenticate_and_authorize

  def index
    if !params[:page] && params[:manager_id]
      @activities = Activity.manager_activities(params[:manager_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:page] && params[:manager_id]
      @activities = Activity.manager_activities(params[:manager_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif !params[:page] && params[:student_id]
      @activities = Activity.student_activities(params[:student_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:page] && params[:student_id]
      @activities = Activity.student_activities(params[:student_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:page] && !params[:manager_id] && !params[:student_id]
      if nested_org_request?(params)
        @activities = Activity.organisation_activities(params[:organisation_id])
          .order("created_at desc").page(params[:page]).per_page(20)
      else
        @activities = Activity.includes(:user, :trackable).order("created_at desc")
          .page(params[:page]).per_page(20)
      end

    else
      if nested_org_request?(params)
        @activities = Activity.organisation_activities(params[:organisation_id])
          .order("created_at desc").page(params[:page]).per_page(20)
      else
        @activities = Activity.includes(:user, :trackable).order("created_at desc")
          .page(params[:page]).per_page(20)
      end
    end

    @activities
  end

end
