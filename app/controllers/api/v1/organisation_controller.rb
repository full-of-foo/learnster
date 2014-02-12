class Api::V1::OrganisationController < ApplicationController
  after_filter only: [:index] { paginate(:organisations) }
  before_filter :authenticate_and_authorize

  def index
    if search_request?
      @organisations = Organisation.search_term(params[:search])
        .page(params[:page]).per_page(20)
      return @organisations
    end

    @organisations = Organisation.all.page(params[:page]).per_page(20)

    if params[:format] == "xlsx"
      type = "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
      respond_to do |format|
      format.xlsx {
        send_data @organisations.to_xlsx
          .to_stream.read, :filename => 'organisations.xlsx', :type => type
       }
      end
    end
    @organisations
  end

  def show
    @organisation = Organisation.find(params[:id])
  end

  def update
    @organisation = Organisation.find(params[:id])

    if @organisation.update permitted_params.org_params
      track_activity @organisation
      render "api/v1/organisation/show"
    else
      respond_with @organisation
    end
  end

  def create
    @organisation = Organisation.new

    attrs = permitted_params.org_params.merge default_attrs
    if @organisation.update attrs
      track_activity @organisation
      render "api/v1/organisation/show"
    else
      respond_with @organisation
    end
  end

  def destroy
    @organisation = Organisation.find(params[:id])
    if @organisation.destroy()
      untrack_trackable params[:id]
      render json: {}
    else
      respond_with @organisation
    end
  end

  def default_attrs
    { created_by: current_user.org_admin? ? current_user : OrgAdmin.first }
  end

end
