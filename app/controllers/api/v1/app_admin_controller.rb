module Api
	module V1

		class AppAdminController < ApplicationController
			load_and_authorize_resource
		    respond_to :json
		    before_filter :require_login

		    def show
		  		@app_admin = AppAdmin.find(params[:id])
			end
		end
		
	end
 end