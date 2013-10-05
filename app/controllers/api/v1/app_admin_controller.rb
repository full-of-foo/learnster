module Api
	module V1

		class AppAdminController < ApplicationController
		    respond_to :json

		    def index
		        @app_admins = AppAdmin.all
		        render "app_admin/index"
		    end

		     def show
		  		@app_admin = AppAdmin.find(params[:id])
		  		render "app_admin/show"
			end
		end
		
	end
 end