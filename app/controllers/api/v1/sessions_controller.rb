module Api
	module V1

		class SessionsController < ApplicationController
			skip_before_filter :require_login, :except => [:destroy]

			def new		
				@user = User.new
			end

			def create
				@user = login(params[:email], params[:password], params[:remember_me])
				if @user
					render json: {
							user: { id: @user.id }
						}, status: 200
				else
					render json: {
							error: "Invalid login"
						}, status: 401
				end
			end

			def destroy
				logout
			end

		end

	end
end