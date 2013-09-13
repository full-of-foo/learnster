class StudentController < ApplicationController
    respond_to :json

    def index
        @students = Student.all
    end

    def show
  		@student = Student.find(params[:id])
	end

	def update
		@student = Student.find(params[:id])
		if @student.update permitted_params.user_params
			render "student/show"
		else
			respond_with @student
		end
	end

	def create
		@student = Student.new
		params = permitted_params.user_params().merge default_attrs

		if @student.update params
			render "student/show"
		else
			respond_with @student
		end
	end

	def destroy
  		student = Student.find(params[:id])
  		student.destroy()
  		render json: {}
	end


	private

		def default_attrs
			#must do this a la client instead
			org = Organisation.find_by(title: params[:attending_org]) 

			{ created_by: current_user, attending_org: org, is_active: false, last_login: Time.zone.now }
		end

 end
