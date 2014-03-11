class Api::V1::WikiSubmissionController < ApplicationController
  after_filter only: [:index] { paginate(:versions) }
  before_filter :authenticate_and_authorize

  def index_versions
    @versions = WikiSubmission.find(params[:wiki_submission_id]).versions

    render "api/v1/version/index"
  end

  def create
    @submission = WikiSubmission.new
    params = permitted_params.wiki_submission_params.merge(create_params)

    if @submission.update params
      track_activity @submission
      render "api/v1/submission/show"
    else
      respond_with @submission
    end
  end

  def update
    @submission = WikiSubmission.find(params[:id])
    params = permitted_params.wiki_submission_params()
    logger.debug params
    logger.debug @submission

    if @submission.update params
      track_activity @submission
      render "api/v1/submission/show"
    else
      respond_with @submission
    end
  end

  def show
    @submission = WikiSubmission.find(params[:id])
    if @submission
      render "api/v1/submission/show"
    else
      respond_with @submission
    end
  end

  def show_version
    @version = PaperTrail::Version.find(params[:version_id])
    @submission = @version.reify

    if @submission
      render "api/v1/submission/show"
    else
      respond_with @submission
    end
  end

  def revert
    @version = PaperTrail::Version.find(params[:id])
    if @version.reify
      @submission = @version.reify
      @submission.save!
      render "api/v1/submission/show"
    else
      @submission = @version.item
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
