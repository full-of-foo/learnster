class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

	  def current_user
	    @current_user ||= User.find(session[:user_id]) if session[:user_id]
	  end

	  def current_organisation
	  	@current_organisation
	  end
	  helper_method :current_user
	  helper_method :current_organisation


	  def permitted_user_params
	  	@permitted_user_params ||= PermittedUserParams.new(params, current_user)
	  end

	  def permitted_organisation_params
	  	@permitted_organisation_params
	  end
	  helper_method :permitted_user_params
	  helper_method :permitted_organisation_params

end
