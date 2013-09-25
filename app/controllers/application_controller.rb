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

  def find_org
      @org = Organisation.find(params[:organisation_id]) if params[:organisation_id]
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def nested_org_request?
    !!params[:organisation_id]
  end

  def search_request?
    !!params[:search]
  end

  def xlsx_request? 
    params[:format] == "xlsx"
  end

  helper_method :current_user
  helper_method :permitted_params
  helper_method :find_org
  helper_method :not_found

  helper_method :nested_org_request?
  helper_method :search_request?
  helper_method :xlsx_request?

end
