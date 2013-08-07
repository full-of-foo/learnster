class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

	  def current_user
	    @current_user ||= User.find(session[:user_id]) if session[:user_id]
	  end
	  helper_method :current_user

	  def permitted_params
	  	@permitted_user_params ||= PermittedUserParams.new(params, current_user)
	  end

	  helper_method :permitted_user_params

end
