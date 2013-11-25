class Api::V1::StudentController < ApplicationController
	respond_to :json
	before_filter :find_org
	before_filter :require_login

	def index
		if search_request?
			@search = Student.search do
				fulltext params[:search]
				with(:org_id).equal_to(params[:organisation_id]) if nested_org_request?(params)
				with(:created_at, Time.zone.now.ago((params[:created_months_ago].to_i).months)..Time.zone.now) if params[:created_months_ago]
				with(:updated_at, Time.zone.now.ago((params[:updated_months_ago].to_i).months)..Time.zone.now) if params[:updated_months_ago]
				paginate :page => 1, :per_page => 10000
			end
			return (@students = @search.results)
		end
		
		@students = nested_org_request?(params) ? @org.students() : Student.all()

		if xlsx_request?
			respond_to do |format|
				format.xlsx {
					send_data @students.to_xlsx.to_stream.read, :filename => 'students.xlsx', 
					:type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
				 }
			end	
		end
		@students
	end

	def show
		@student = Student.find(params[:id])
	end

	def update
		@student = Student.find(params[:id])

		if @student.update permitted_params.user_params().merge update_params
			track_activity @student
			render "api/v1/student/show"
		else
			respond_with @student
		end
	end

	def create
		@student = Student.new
		params = permitted_params.user_params().merge create_params

		if @student.update params
			track_activity @student
			render "api/v1/student/show"
		else
			respond_with @student
		end
	end

	def destroy
		@student = Student.find(params[:id])
		
		if @student.destroy()
			track_activity @student
			render json: {}
		else
			respond_with @student
		end
	end

	def import
		if nested_org_request?(params) and ['.csv', '.xls', '.xlsx'].include? File.extname(params[:qqfilename])
			import_status_data = Student.import_with_validation(params[:qqfile], @org, current_user)
			if import_status_data.values.all? { |value| value == true } and not import_status_data.empty?
				render :json => { :success => true }	
			else
				render :json => { :success => false, :error => import_status_data,
				 :preventRetry => true }, :status => 422
			end
		else
			render :json => { :success => false, :error => { "File Type Error" => "Invalid file uploaded" },
			 :preventRetry => true }, :status => :unauthorized
		end
	end

	private

		# virtual params on update
		def update_params
			{ password: params[:password], password_confirmation: params[:password_confirmation] }
		end

		# virtual params on create
		def create_params
			org = Organisation.find_by(title: params[:attending_org]) if current_user.app_admin?
			org = current_user.admin_for if current_user.org_admin?

			{ created_by: current_user, attending_org: org, is_active: false, 
				last_login: Time.zone.now, password: params[:password], 
				password_confirmation: params[:password_confirmation] }
		end
end