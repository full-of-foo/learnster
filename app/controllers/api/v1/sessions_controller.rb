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
					redirect_to root_url
				else
					render json: {
							errors: { email: "", password: ["Invalid email or password"] }
				 		}, status: 422
				end
			end

			def destroy
				logout
				redirect_to root_url
			end

		end

	end
end