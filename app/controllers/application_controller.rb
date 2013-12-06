class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session
	before_filter :authorize
	before_filter proc { |controller| controller.response.headers['x-url'] = controller.request.fullpath } 
	skip_before_filter :verify_authenticity_token, :if => proc { |c| c.request.format == 'application/json' }


	def index
		@user ||= current_user
		if @user
		  gon.rabl
		end
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
	
	def permitted_params
		@permitted_params ||= PermittedParams.new(params, current_user)
	end

	def track_activity(trackable, action = params[:action], user = nil)
		user ||= current_user
  	user.activities.create! action: action, trackable: trackable
	end

	def nested_org_request?(params)
		!!params[:organisation_id]
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
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	helper_method :current_user

	def current_permission
	  @current_permission ||= Permission.new(current_user)
	end

	def require_login
		render json: { error: "Not authorized" }, status: 401 if current_user.nil?
	end

	def authorize
	  if !current_permission.allow?(params[:controller], params[:action], params)
	    render json: { error: "Not authorized" }, status: 401
	  end
	end
end
