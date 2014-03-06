class Api::V1::ContentUploadController < ApplicationController
  before_filter :authenticate_and_authorize

  def create
    file = params[:qqfile].is_a?(ActionDispatch::Http::UploadedFile) ? params[:qqfile] : params[:file]
    @supplement_content = ContentUpload.new
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
    @supplement_content = ContentUpload.find(params[:id])
    params = permitted_params.supplement_content_params()

    if @supplement_content.update params
      track_activity @supplement_content
      render "api/v1/supplement_content/show"
    else
      respond_with @supplement_content
    end
  end

  private
    def create_params
       params[:module_supplement] ? {module_supplement: ModuleSupplement.find(params[:module_supplement][:id])} : {}
    end

end
