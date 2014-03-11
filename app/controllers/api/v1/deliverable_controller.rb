class Api::V1::DeliverableController < ApplicationController
  after_filter only: [:index] { paginate(:deliverables) }
  before_filter :authenticate_and_authorize
  before_filter :find_org, only: [:index]


  def index
    if params[:module_supplement_id]
      @deliverables = ModuleSupplement.find(params[:module_supplement_id])
        .deliverables.order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:educator_id]
      @deliverables = Deliverable.educator_deliverables(params[:educator_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:student_id] && !params[:deliverable_id]
      @deliverables = Deliverable.student_deliverables(params[:student_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    elsif params[:student_id] && params[:deliverable_id]
      @deliverables = Deliverable.student_deliverables(params[:student_id], nil, params[:deliverable_id])
        .order("created_at desc").page(params[:page]).per_page(20)

    else
      @deliverables = nested_org_request?(params) ? Deliverable
        .organisation_deliverables(@org.id).order("created_at desc").page(params[:page])
        .per_page(20) : Deliverable.all.order("created_at desc").page(params[:page]).per_page(20)

    end

    return @deliverables
  end

  def show
    @deliverable = Deliverable.find(params[:id])
  end

  def create
    @deliverable = Deliverable.new
    params = permitted_params.deliverable_params.merge(create_and_update_params)

    if @deliverable.update params
      track_activity @deliverable
      render "api/v1/deliverable/show"
    else
      respond_with @deliverable
    end
  end

  def update
    @deliverable = Deliverable.find(params[:id])
    params = permitted_params.deliverable_params.merge(create_and_update_params)
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
    def create_and_update_params
      new_params = {}
      new_params[:module_supplement] = ModuleSupplement.find(params[:module_supplement][:id]) if params[:module_supplement]
      new_params.merge(date_params)
    end

    def date_params
      date_params = {}
      date_params[:due_date] = Date.parse(params[:due_date].gsub('/', '-')).in_time_zone if !params[:due_date].empty?
      date_params
    end

end
