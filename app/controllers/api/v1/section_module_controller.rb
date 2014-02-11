class Api::V1::SectionModuleController < ApplicationController
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]


  def index
    if params[:course_section_id]
      @section_modules = SectionModule.where(course_section_id: params[:course_section_id])
        .page(params[:page]).per_page(20)
    else
      @section_modules = nested_org_request?(params) ? SectionModule.organisation_section_modules(@org.id)
          .page(params[:page]).per_page(20) : SectionModule.all.page(params[:page]).per_page(20)
    end

  end

  def show
    @section_module = SectionModule.find(params[:id])
  end

  def create
    @section_module = SectionModule.new
    params = permitted_params.section_module_params.merge create_params
    logger.debug params
    if @section_module.update params
      track_activity @section_module
      render "api/v1/section_module/show"
    else
      respond_with @section_module
    end
  end

  def destroy
    @section_module = SectionModule
      .where(learning_module_id: params[:learning_module_id], course_section_id: params[:course_section_id])
        .first

    if @section_module && @section_module.destroy()
      track_activity @section_module
      render json: {}
    else
      respond_with @section_module
    end
  end

  private
    def create_params
      org_id = CourseSection.find(params[:course_section_id]).course.organisation_id
      learning_module_id = LearningModule
        .find_by_org_and_title(org_id, params[:learning_module]).id

      { learning_module_id: learning_module_id }
    end

end
