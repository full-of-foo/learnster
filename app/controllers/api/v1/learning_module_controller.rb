class Api::V1::LearningModuleController < ApplicationController
  after_filter only: [:index] { paginate(:learning_modules) }
  before_filter :authenticate_and_authorize
  before_filter :find_org


  def index
    @learning_modules = nested_org_request?(params) ? LearningModule.organisation_modules(@org.id)
        .page(params[:page]).per_page(20) : Course.all.page(params[:page]).per_page(20)
  end

  def show
    @course = Course.find(params[:id])
  end

end
