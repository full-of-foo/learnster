class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	helper :all

	before_filter :authorize
	before_filter proc { |controller| controller.response.headers['x-url'] = controller.request.fullpath } 


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

	def current_permission
	  @current_permission ||= Permission.new(current_user)
	end

	def authorize
	  if !current_permission.allow?(params[:controller], params[:action], params)
	    render json: { error: "Not authorized" }, status: 401
	  end
	end
end
