class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  def index
    gon.rabl template: "app/views/user/show.json.rabl", as: "current_user"
  end

  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end

  def permitted_params
  	@permitted_params ||= PermittedParams.new(params, Student.first())
  end

  helper_method :permitted_params

end
