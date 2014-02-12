class Api::V1::SupplementContentController < ApplicationController
  after_filter only: [:index] { paginate(:supplement_contents) }
  before_filter :authenticate_and_authorize


  def index
    if params[:module_supplement_id]
      @supplement_contents = ModuleSupplement.find(params[:module_supplement_id]).supplement_contents
    else
      @supplement_contents = SupplementContent.all
    end

    return @supplement_contents
  end

  def show
    @module_supplement = SupplementContent.find(params[:id])
  end

  # def create
  #   @module_supplement = SupplementContent.new
  #   params = permitted_params.module_supplement_params

  #   if @module_supplement.update params
  #     track_activity @module_supplement
  #     render "api/v1/module_supplement/show"
  #   else
  #     respond_with @module_supplement
  #   end
  # end

  # def update
  #   @module_supplement = SupplementContent.find(params[:id])
  #   params = permitted_params.module_supplement_params

  #   if @module_supplement.update params
  #     track_activity @module_supplement
  #     render "api/v1/module_supplement/show"
  #   else
  #     respond_with @module_supplement
  #   end
  # end

  def destroy
    @module_supplement = SupplementContent.find(params[:id])

    if @module_supplement.destroy()
      untrack_trackable params[:id]
      render json: {}
    else
      respond_with @module_supplement
    end
  end

end
