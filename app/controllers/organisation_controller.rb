class OrganisationController < ApplicationController
    respond_to :json

    def index
    	@search = Organisation.search do
    		fulltext params[:search]
    	end
        @organisations = @search.results
    end

    def show
  		@organisation = Organisation.find(params[:id])
	end

	def update
		@organisation = Organisation.find(params[:id])
		
		if @organisation.update permitted_params.org_params
			render "organisation/show"
		else
			respond_with @organisation
		end
	end

	def create
		@organisation = Organisation.new
		
		attrs = permitted_params.org_params.merge default_attrs
		if @organisation.update attrs
			render "organisation/show"
		else
			respond_with @organisation
		end
	end

	def destroy
		organisation = Organisation.find(params[:id])
  		organisation.destroy()
  		render json: {}
	end

	def default_attrs
		{ created_by: current_user }
	end

end
