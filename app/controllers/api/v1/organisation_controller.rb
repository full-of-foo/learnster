class Api::V1::OrganisationController < ApplicationController
	respond_to :json
	before_filter :require_login

	def index
		if params[:search]
			@search = Organisation.search do
				fulltext params[:search]
			end
			return (@organisations = @search.results)
		end

		@organisations = Organisation.all
		
		if params[:format] == "xlsx"    		
			respond_to do |format|
			format.xlsx {
				send_data @organisations.to_xlsx.to_stream.read, :filename => 'organisations.xlsx', :type => "application/\
				vnd.openxmlformates-officedocument.spreadsheetml.sheet"
			 }
			end	
		else
		  @organisations
		end
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
			track_activity @organisation
			render json: {}
		else
			respond_with @organisation
		end
	end

	def default_attrs
		{ created_by: current_user.org_admin? ? current_user : OrgAdmin.first }
	end

end