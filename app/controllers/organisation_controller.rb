class OrganisationController < ApplicationController
    respond_to :json

    def index
       @organisations = Organisation.all
    end

     def show
  		@organisation = Organisation.find(params[:id])
	end

end
