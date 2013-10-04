class AppAdminController < ApplicationController
	before_filter :authenticate_user!
    respond_to :json

    def index
        @app_admins = AppAdmin.all
    end

     def show
  		@app_admin = AppAdmin.find(params[:id])
	end

 end