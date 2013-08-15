class OrganisationController < ApplicationController
    respond_to :json

    def index
       @organisations = Organisation.all
       gon.rabl
    end

    # def index
    #     render :json => Organisation.all().to_json(:include => { :created_by => { :only => :id }, :admin_for => { :only => :id }})
    # end

    # def show
    #     render :json => Organisation.find(params[:id]).to_json(:include => { :created_by => { :only => :id }, :admin_for => { :only => :id }})
    # end

    # def create
    #     render :json => Organisation.create(permitted_organisation_params.organisation)
    # end

    # def update
    #     render :json => Organisation.update(params[:id], permitted_organisation_params.organisation)
    # end

    # def destroy
    #     render :json => Organisation.destroy(params[:id])
    # end
end
