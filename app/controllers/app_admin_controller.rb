class AppAdminController < ApplicationController
    respond_to :json

    def index
        @app_admins = AppAdmin.all
    end

     def show
  		@app_admin = AppAdmin.find(params[:id])
	end

 end