class Api::V1::SubmissionUploadController < ApplicationController
  before_filter :authenticate_and_authorize

  def create
    file = params[:qqfile].is_a?(ActionDispatch::Http::UploadedFile) ? params[:qqfile] : params[:file]
    @submission = SubmissionUpload.new
    @submission.file_upload = file
    params = permitted_params.submission_params.merge(create_params)

    if @submission.update params
      track_activity @submission
      render "api/v1/submission/show"
    else
      respond_with @submission
    end
  end

  def update
    @submission = SubmissionUpload.find(params[:id])
    params = permitted_params.submission_params()

    if @submission.update params
      track_activity @submission
      render "api/v1/submission/show"
    else
      respond_with @submission
    end
  end

  private
    def create_params
      new_params = {}
      new_params[:deliverable] = Deliverable.find(params[:deliverable][:id]) if params[:deliverable]
      new_params[:student] = current_user if current_user.student?
      new_params
    end

end
