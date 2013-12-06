class Api::V1::AppAdminController < ApplicationController
  before_filter :authenticate_and_authorize

	def show
		@app_admin = AppAdmin.find(params[:id])
	end
end