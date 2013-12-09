class Api::V1::OrgAdminController < ApplicationController
  before_filter :authenticate_and_authorize
  before_filter :find_org

  def index
    if search_request?
      @org_admins = OrgAdmin.search_term(params[:search])                                  if search_term_request?(params)
      @org_admins = OrgAdmin.search_term(params[:search], @org)                            if nested_org_term_search?(params)
      @org_admins = OrgAdmin.search_range(params[:created_months_ago], :created_at)        if created_at_search?(params)
      @org_admins = OrgAdmin.search_range(params[:updated_months_ago], :updated_at)        if updated_at_search?(params)
      @org_admins = OrgAdmin.search_range(params[:created_months_ago], :created_at, @org)  if nested_org_created_at_search?(params)
      @org_admins = OrgAdmin.search_range(params[:updated_months_ago], :updated_at, @org)  if nested_org_updated_at_search?(params)
      return @org_admins
    end
    
    @org_admins = nested_org_request?(params) ? @org.admins() : OrgAdmin.all()

    if xlsx_request?
      respond_to do |format|
        format.xlsx {
          send_data @org_admins.to_xlsx.to_stream.read, :filename => 'admins.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
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
 