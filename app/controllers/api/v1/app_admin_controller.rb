module Api
	module V1

		class AppAdminController < ApplicationController
		    respond_to :json
		    before_filter :require_login

		    def index
		        @app_admins = AppAdmin.all
		    end

		     def show
		  		@app_admin = AppAdmin.find(params[:id])
			end
		end
		
	end
 end