class Api::V1::SubmissionController < ApplicationController
  after_filter only: [:index] { paginate(:submissions) }
  before_filter :authenticate_and_authorize

  def index
    if params[:supplement_id]
      @submissions = Submission.supplement_submissions(params[:supplement_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:deliverable_id] && !params[:student_id]
      @submissions = Deliverable.find(params[:deliverable_id]).submissions
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:student_id] && !params[:deliverable_id]
      @submissions = Student.find(params[:student_id]).submissions
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:student_id] && params[:deliverable_id]
      @submissions = Submission.where(student_id: params[:student_id], deliverable_id: params[:deliverable_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    end

    return @submissions
  end

  def show
    @submission = Submission.find(params[:id])
  end


  def destroy
    @submission = Submission.find(params[:id])

    if @submission.destroy()
      untrack_trackable params[:id]
      render json: {}
    else
      respond_with @submission
    end
  end

end
