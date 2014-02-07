class Api::V1::CourseController < ApplicationController
  after_filter only: [:index] { paginate(:courses) }
  before_filter :authenticate_and_authorize
  before_filter :find_org


  def index
    @courses = nested_org_request?(params) ? @org.courses()
        .page(params[:page]).per_page(20) : Course.all.page(params[:page]).per_page(20)
  end

  def show
    @course = Course.find(params[:id])
  end

end
