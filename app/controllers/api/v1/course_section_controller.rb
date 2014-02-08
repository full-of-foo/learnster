class Api::V1::CourseSectionController < ApplicationController
  after_filter only: [:index] { paginate(:course_sections) }
  before_filter :authenticate_and_authorize

  before_filter :find_org


  def index
    if !params[:course_id]
      @course_sections = nested_org_request?(params) ? CourseSection.organisation_course_sections(@org.id)
          .page(params[:page]).per_page(20) : CourseSection.all.page(params[:page]).per_page(20)
    else
      @course_sections = CourseSection.organisation_course_sections(nil, params[:course_id])
        .page(params[:page]).per_page(20)
    end

    @course_sections
  end

  def show
    @course_sections = CourseSection.find(params[:id])
  end

end
