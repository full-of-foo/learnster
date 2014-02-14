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
    @supplement_content = SupplementContent.find(params[:id])
  end

  def create
    file = params[:qqfile].is_a?(ActionDispatch::Http::UploadedFile) ? params[:qqfile] : params[:file]
    @supplement_content = SupplementContent.new
    @supplement_content.file_upload = file
    params = permitted_params.supplement_content_params.merge(create_params)

    if @supplement_content.update params
      track_activity @supplement_content
      render "api/v1/supplement_content/show"
    else
      respond_with @supplement_content
    end
  end

  def update
    @supplement_content = SupplementContent.find(params[:id])
    params = permitted_params.supplement_content_params()

    if @supplement_content.update params
      track_activity @supplement_content
      render "api/v1/supplement_content/show"
    else
      respond_with @supplement_content
    end
  end

  def destroy
    @module_supplement = SupplementContent.find(params[:id])

    if @module_supplement.destroy()
      untrack_trackable params[:id]
      render json: {}
    else
      respond_with @module_supplement
    end
  end

  private
    def create_params
       params[:module_supplement] ? {module_supplement: ModuleSupplement.find(params[:module_supplement][:id])} : {}
    end

end
