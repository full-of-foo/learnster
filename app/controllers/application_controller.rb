class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  def index
    @user = current_user
    gon.rabl
  end

  def current_user
    @current_user ||= AppAdmin.first()
  end

  def permitted_params
  	@permitted_params ||= PermittedParams.new(params, current_user)
  end

  helper_method :current_user
  helper_method :permitted_params

end
