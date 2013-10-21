class Api::V1::SessionsController < ApplicationController
	skip_before_filter :require_login, :except => [:destroy]

	def new		
		@user = User.new
	end

	def create
		@user = login(params[:email], params[:password], params[:remember_me])
		if @user
			@user.update(last_login: Time.zone.now, is_active: true)
			render "application/show_current_user.json.rabl"
		else
			render json: {
					errors: { email: "", password: ["Invalid email or password"] }
				}, status: 422
		end
	end

	def destroy
		if current_user
			current_user.update(is_active: false)
			logout
			render :json => {
				'csrfParam' => request_forgery_protection_token,
				'csrfToken' => form_authenticity_token
			}
		else
			render json: {}
		end
	end

end