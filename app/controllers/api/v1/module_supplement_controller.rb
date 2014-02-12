class Api::V1::ModuleSupplementController < ApplicationController
  after_filter only: [:index] { paginate(:module_supplements) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]


  def index
    if search_request?
      @module_supplements = ModuleSupplement.search_term(params[:search]).page(params[:page]).per_page(20) if search_term_request?(params)
      return @module_supplements
    end


    if params[:module_id]
      @module_supplements = LearningModule.find(params[:module_id]).module_supplements
        .page(params[:page]).per_page(20)
    else
      @module_supplements = ModuleSupplement.all.page(params[:page]).per_page(20)
    end

    return @module_supplements
  end

  def show
    @learning_module = ModuleSupplement.find(params[:id])
  end

  def create
    @learning_module = ModuleSupplement.new
    params = permitted_params.learning_module_params().merge create_and_update_params

    if @learning_module.update params
      track_activity @learning_module
      render "api/v1/learning_module/show"
    else
      respond_with @learning_module
    end
  end

  def update
    @learning_module = ModuleSupplement.find(params[:id])
    params = permitted_params.learning_module_params().merge create_and_update_params

    if @learning_module.update params
      track_activity @learning_module
      render "api/v1/learning_module/show"
    else
      respond_with @learning_module
    end
  end

  def destroy
    @learning_module = ModuleSupplement.find(params[:id])

    if @learning_module.destroy()
      untrack_trackable params[:id]
      render json: {}
    else
      respond_with @learning_module
    end
  end

  private
    def create_and_update_params
      # educator = OrgAdmin.where(admin_for: params[:organisation_id], email: params[:educator]).first

      # { educator: educator }
      {}
    end

end
