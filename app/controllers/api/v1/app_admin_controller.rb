class Api::V1::AppAdminController < ApplicationController
	respond_to :json

	def show
		@app_admin = AppAdmin.find(params[:id])
	end
end