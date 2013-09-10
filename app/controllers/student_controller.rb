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

 end