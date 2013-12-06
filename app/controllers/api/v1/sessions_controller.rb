class Api::V1::SessionsController < ApplicationController
  skip_before_filter :authenticate_and_authorize, :except => [:destroy]

  def new   
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:email])
    
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
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
      session[:user_id] = nil
      render :json => {
        'csrfParam' => request_forgery_protection_token,
        'csrfToken' => form_authenticity_token
      }
    else
      render json: {}
    end
  end

end