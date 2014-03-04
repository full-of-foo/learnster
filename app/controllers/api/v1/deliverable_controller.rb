class Api::V1::DeliverableController < ApplicationController
  after_filter only: [:index] { paginate(:deliverables) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]


  def index
    if params[:module_supplement_id]
      @deliverables = ModuleSupplement.find(params[:module_supplement_id])
        .deliverables

    elsif params[:educator_id]
      @deliverables = Deliverable.educator_deliverables(params[:educator_id])

    elsif params[:student_id]
      @deliverables = Deliverable.student_deliverables(params[:student_id])

    else
      @deliverables = nested_org_request?(params) ? Deliverable
        .organisation_deliverables(@org.id) : Deliverable.all

    end

    return @deliverables
  end

  def show
    @deliverable = Deliverable.find(params[:id])
  end

  def create
    @deliverable = Deliverable.new
    params = permitted_params.deliverable_params.merge(create_params)

    if @deliverable.update params
      track_activity @deliverable
      render "api/v1/deliverable/show"
    else
      respond_with @deliverable
    end
  end

  def update
    @deliverable = Deliverable.new
    params = permitted_params.deliverable_params.merge(date_params)

    if @deliverable.update params
      track_activity @deliverable
      render "api/v1/deliverable/show"
    else
      respond_with @deliverable
    end
  end

  def destroy
    @deliverable = Deliverable.find(params[:id])

    if @deliverable.destroy()
      untrack_trackable params[:id]
      render json: {}
    else
      respond_with @deliverable
    end
  end

  private
    def create_params
      create_params = {}
      create_params[:module_supplement] = ModuleSupplement.find(params[:module_supplement][:id])    if params[:module_supplement]
      create_params.merge(date_params)
    end

    def date_params
      date_params = {}
      date_params[:due_date] = Date.parse(params[:due_date].gsub('/', '-')).in_time_zone if !params[:due_date].empty?
      date_params
    end

end
