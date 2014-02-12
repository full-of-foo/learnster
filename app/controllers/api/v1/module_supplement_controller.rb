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
    @module_supplement = ModuleSupplement.find(params[:id])
  end

  def create
    @module_supplement = ModuleSupplement.new
    params = permitted_params.module_supplement_params

    if @module_supplement.update params
      track_activity @module_supplement
      render "api/v1/module_supplement/show"
    else
      respond_with @module_supplement
    end
  end

  def update
    @module_supplement = ModuleSupplement.find(params[:id])
    params = permitted_params.module_supplement_params

    if @module_supplement.update params
      track_activity @module_supplement
      render "api/v1/module_supplement/show"
    else
      respond_with @module_supplement
    end
  end

  def destroy
    @module_supplement = ModuleSupplement.find(params[:id])

    if @module_supplement.destroy()
      untrack_trackable params[:id]
      render json: {}
    else
      respond_with @module_supplement
    end
  end

end
