class OrgAdminController < ApplicationController
    respond_to :json

    def index
    	if params[:format] == "xlsx"
    		@org_admins = OrgAdmin.all
    		
    		respond_to do |format|
  			format.xlsx {
            	send_data @org_admins.to_xlsx.to_stream.read, :filename => 'org_admin.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
       		 }
  			end
    	end

    	@search = OrgAdmin.search do
    		fulltext params[:search]
    	end
        @org_admins = @search.results
    end

    def show
  		@org_admin = OrgAdmin.find(params[:id])
	end

	def update
		@org_admin = OrgAdmin.find(params[:id])
		if @org_admin.update permitted_params.org_admin_params
			render "org_admin/show"
		else
			respond_with @org_admin
		end
	end

	def create
		@org_admin = OrgAdmin.new
		params = permitted_params.org_admin_params.merge default_attrs
		if @org_admin.update params
			render "org_admin/show"
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

		def default_attrs
			org = Organisation.find_by(title: params[:admin_for]) 

			{ created_by: current_user, admin_for: org, is_active: false, last_login: Time.zone.now }
		end
 end