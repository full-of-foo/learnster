class Api::V1::AppAdminController < ApplicationController
	respond_to :json
	# before_filter :require_login

	def show
		@app_admin = AppAdmin.find(params[:id])
	end
end