class Api::V1::OrgAdminController < ApplicationController
	respond_to :json
	before_filter :find_org
	before_filter :require_login
	

	def index
		if search_request?
			@org_admins = OrgAdmin.search_term(params[:search]) 							if not nested_org_request?(params)
			@org_admins = OrgAdmin.search_term(params[:search], @org) 				if nested_org_request?(params)
			@org_admins = OrgAdmin.search_range(params[:created_months_ago]) 	if params[:created_months_ago]
			@org_admins = OrgAdmin.search_range(params[:updated_months_ago]) 	if params[:updated_months_ago]
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
			org = Organisation.find_by(title: params[:admin_for])  	  if current_user.app_admin?
			org = current_user.admin_for 							  if current_user.org_admin?

			{ created_by: current_user, admin_for: org, is_active: false, 
				last_login: Time.zone.now, password: params[:password], 
				password_confirmation: params[:password_confirmation] }
		end
end
 