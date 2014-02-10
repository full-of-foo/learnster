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
    @course_section = CourseSection.includes(:course).where(id: params[:id]).first
  end

  def create
    @course_section = CourseSection.new
    params = permitted_params.course_secion_params.merge(create_params())

    if @course_section.update params
      track_activity @course_section
      render "api/v1/course_section/show"
    else
      respond_with @course_section
    end
  end

  def destroy
    @course_section = CourseSection.find(params[:id])

    if @course_section.destroy()
      track_activity @course_section
      render json: {}
    else
      respond_with @course_section
    end
  end

  private
    #virtual params on create
    def create_params
      provisioned_by = OrgAdmin.where(email: params[:provisioned_by]).first
      { provisioned_by: provisioned_by }
    end

end
