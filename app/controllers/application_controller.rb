class ApplicationController < ActionController::Base
  force_ssl if Rails.env.production?
  protect_from_forgery with: :null_session
  before_filter proc { |controller| controller.response.headers['x-url'] = controller.request.fullpath }
  skip_before_filter :verify_authenticity_token, :if => proc { |c| c.request.format == 'application/json' }
  respond_to :json

  def index
    @user ||= current_user

    gon.rabl if @user
    render "application/index.html.erb"
  end

  def show_current_user
    @user ||= current_user
    if @user
      render "application/show_current_user"
    else
      render json: {}
    end
  end

  def track_activity(trackable, action = params[:action], user = nil)
    user ||= current_user
    user.activities.create! action: action, trackable: trackable
  end

  def untrack_trackable(trackable_id)
    Activity.delete_all(trackable_id: trackable_id)
  end

  def nested_org_request?(params)
    !!params[:organisation_id]
  end

  def nested_org_term_search?(params)
    !!params[:organisation_id] && !!params[:search]
  end

  def nested_org_created_at_search?(params)
    !!params[:created_months_ago] && nested_org_request?(params)
  end

  def nested_org_updated_at_search?(params)
    !!params[:updated_months_ago] && nested_org_request?(params)
  end

  def updated_at_search?(params)
    !!params[:updated_months_ago] && !nested_org_request?(params)
  end

  def created_at_search?(params)
    !!params[:created_months_ago] && !nested_org_request?(params)
  end

  def search_term_request?(params)
    params[:search] && !params[:organisation_id]
  end

  def search_request?
    !!params[:search]
  end

  def xlsx_request?
    params[:format] == "xlsx"
  end

  def find_org
    @org = Organisation.find(params[:organisation_id]) if params[:organisation_id]
  end

  def current_user
    @current_user
  end
  helper_method :current_user


  # 404 handling

  rescue_from ActionController::RoutingError, :with => :render_404

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_404
    redirect_to((root_path + "#/404"))
  end


  # Auth and permissions

  def permitted_params
    @permitted_params ||= PermittedParams.new(params, current_user)
  end

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def authenticate_and_authorize
    request.headers['Authorization'] = cookies['auth_header'] if xlsx_request?
    authenticated_user = authenticate_with_http_token { |t, o| User.authenticated_user(t) }
    if authenticated_user
      @current_user = authenticated_user
      cookies['auth_header'] = request.headers['Authorization']
      cookies['user_id']     = @current_user.id
      cookies['user_type']   = @current_user.type

      has_permission = current_permission.allow?(params[:controller], params[:action], params)
      render(json: { error: "Not authorized" }, status: 401) if !has_permission
    else
      request_http_token_authentication
    end
  end

end
