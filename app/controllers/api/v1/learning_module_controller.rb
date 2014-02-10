class Api::V1::LearningModuleController < ApplicationController
  after_filter only: [:index] { paginate(:learning_modules) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]


  def index
    if params[:course_section_id]
      @learning_modules = CourseSection.find(params[:course_section_id]).learning_modules
        .page(params[:page]).per_page(20)
    else
      @learning_modules = nested_org_request?(params) ? LearningModule.organisation_modules(@org.id)
          .page(params[:page]).per_page(20) : LearningModule.all.page(params[:page]).per_page(20)
    end
  end

  def show
    @learning_module = LearningModule.find(params[:id])
  end

end
