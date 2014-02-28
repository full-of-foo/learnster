class Api::V1::SupplementContentController < ApplicationController
  after_filter only: [:index] { paginate(:supplement_contents) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]


  def index
    if params[:module_supplement_id]
      @supplement_contents = ModuleSupplement.find(params[:module_supplement_id])
        .supplement_contents

    elsif params[:educator_id]
      @supplement_contents = SupplementContent.educator_contents(params[:educator_id])

    elsif params[:student_id]
      @supplement_contents = SupplementContent.student_contents(params[:student_id])

    else
      @supplement_contents = nested_org_request?(params) ? SupplementContent
        .organisation_contents(@org.id) : SupplementContent.all

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
