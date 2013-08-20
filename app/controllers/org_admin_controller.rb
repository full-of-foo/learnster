class OrgAdminController < ApplicationController
    respond_to :json

    def index
        @org_admins = OrgAdmin.all
    end

    def show
  		@org_admin = OrgAdmin.find(params[:id])
	end

 end