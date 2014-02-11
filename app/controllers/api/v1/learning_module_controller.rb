class Api::V1::LearningModuleController < ApplicationController
  after_filter only: [:index] { paginate(:learning_modules) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]


  def index
    if search_request?
      @learning_modules = LearningModule.search_term(params[:search]).page(params[:page]).per_page(20)       if search_term_request?(params)
      @learning_modules = LearningModule.search_term(params[:search], @org).page(params[:page]).per_page(20) if nested_org_term_search?(params)
      return @learning_modules
    end


    if params[:course_section_id]
      @learning_modules = CourseSection.find(params[:course_section_id]).learning_modules
        .page(params[:page]).per_page(20)
    else
      @learning_modules = nested_org_request?(params) ? LearningModule.organisation_modules(@org.id)
          .page(params[:page]).per_page(20) : LearningModule.all.page(params[:page]).per_page(20)
    end

    if xlsx_request?
      respond_to do |format|
        format.xlsx {
          send_data @learning_modules.to_xlsx.to_stream.read, :filename => 'learning_modules.xlsx',
          :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
         }
      end
    end
    return @learning_modules
  end

  def show
    @learning_module = LearningModule.find(params[:id])
  end

  def create
    @learning_module = LearningModule.new
    params = permitted_params.learning_module_params().merge create_params

    if @learning_module.update params
      track_activity @learning_module
      render "api/v1/learning_module/show"
    else
      respond_with @learning_module
    end
  end

  def destroy
    @learning_module = LearningModule.find(params[:id])

    if @learning_module.destroy()
      track_activity @learning_module
      render json: {}
    else
      respond_with @learning_module
    end
  end

  private
    def create_params
      educator = OrgAdmin.where(admin_for: params[:organisation_id], email: params[:educator]).first

      { educator: educator }
    end

end
