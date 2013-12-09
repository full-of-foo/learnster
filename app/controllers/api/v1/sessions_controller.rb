class Api::V1::SessionsController < ApplicationController
  skip_before_filter :authenticate_and_authorize, :except => [:destroy]

  def new   
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:email])
    
    if @user && @user.authenticate(params[:password])
      @current_user = @user
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

      @current_user = nil
      cookies.delete('auth_header') if !!cookies['auth_header']
      cookies.delete('user_id')     if !!cookies['user_id']
      cookies.delete('user_type')   if !!cookies['user_type']

      render :json => {
        'csrfParam' => request_forgery_protection_token,
        'csrfToken' => form_authenticity_token
      }
    else
      render json: {}
    end
  end

end