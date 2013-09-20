class OrgAdminController < ApplicationController
    respond_to :json
    before_filter :find_org
    

    def index
    	if params[:search]
	    	@search = OrgAdmin.search do
	    		fulltext params[:search]
	    	end
	        return (@org_admins = @search.results)
    	end

    	@org_admins = OrgAdmin.all
    	
    	if params[:format] == "xlsx"    		
    		respond_to do |format|
  			format.xlsx {
            	send_data @org_admins.to_xlsx.to_stream.read, :filename => 'organisation_admins.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
       		 }
  			end	
	    elsif @org
	      @org_admins = @org.admins
	    else
	      @org_admins
        end
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