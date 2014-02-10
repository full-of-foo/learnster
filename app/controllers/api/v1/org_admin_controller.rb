class Api::V1::OrgAdminController < ApplicationController
  after_filter only: [:index] {
    paginate(:org_admins) if not params[:created_months_ago] and not params[:updated_months_ago] and not params[:from_role]
  }

  before_filter :authenticate_and_authorize
  before_filter :find_org

  def index
    if search_request?
      @org_admins = OrgAdmin.search_term(params[:search]).page(params[:page]).per_page(20)        if search_term_request?(params)
      @org_admins = OrgAdmin.search_term(params[:search], @org).page(params[:page]).per_page(20)  if nested_org_term_search?(params)
      @org_admins = OrgAdmin.search_term(params[:search], @org, params[:from_role])               if params[:from_role]
      @org_admins = OrgAdmin.search_range(params[:created_months_ago], :created_at)               if created_at_search?(params)
      @org_admins = OrgAdmin.search_range(params[:updated_months_ago], :updated_at)               if updated_at_search?(params)
      @org_admins = OrgAdmin.search_range(params[:created_months_ago], :created_at, @org)         if nested_org_created_at_search?(params)
      @org_admins = OrgAdmin.search_range(params[:updated_months_ago], :updated_at, @org)         if nested_org_updated_at_search?(params)
      return @org_admins
    end

    @org_admins = nested_org_request?(params) ? @org.admins()
    .page(params[:page]).per_page(20) : OrgAdmin.all().page(params[:page]).per_page(20)

    if xlsx_request?
      respond_to do |format|
        format.xlsx {
          send_data @org_admins.to_xlsx.to_stream.read, :filename => 'admins.xlsx',
          :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
         }
      end
    end
    @org_admins
   end

  def show
    @org_admin = OrgAdmin.find(params[:id])
  end

  def update
    @org_admin = OrgAdmin.find(params[:id])
    if @org_admin.update permitted_params.org_admin_params().merge update_params
      render "api/v1/org_admin/show"
    else
      respond_with @org_admin
    end
  end

  def create
    @org_admin = OrgAdmin.new
    params = permitted_params.org_admin_params().merge create_params
    if @org_admin.update params
      render "api/v1/org_admin/show"
    else
      respond_with @org_admin
    end
  end

  def destroy
    org_admin = OrgAdmin.find(params[:id])
    org_admin.destroy()
    render json: {}
  end

  def import
    if nested_org_request?(params) and ['.csv', '.xls', '.xlsx'].include? File.extname(params[:qqfilename])
      import_status_data = OrgAdmin.import_with_validation(params[:qqfile], @org, current_user)
      if import_status_data.values.all? { |value| value == true } and not import_status_data.empty?
        render :json => { :success => true }
      else
        render :json => { :success => false, :error => import_status_data,
         :preventRetry => true }, :status => 422
      end
    else
      render :json => { :success => false, :error => { "File Type Error" => "Invalid file uploaded" },
       :preventRetry => true }, :status => :unauthorized
    end
  end


  private

    #virtual params on update
    def update_params
      { password: params[:password], password_confirmation: params[:password_confirmation] }
    end

    #virtual params on create
    def create_params
      org = Organisation.find_by(title: params[:admin_for])     if current_user.app_admin?
      org = current_user.admin_for                if current_user.org_admin?

      { created_by: current_user, admin_for: org, is_active: false,
        last_login: Time.zone.now, password: params[:password],
        password_confirmation: params[:password_confirmation] }
    end
end

