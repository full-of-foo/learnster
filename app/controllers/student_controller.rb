class StudentController < ApplicationController
    respond_to :json

    def index
        @students = Student.all
    end

    def show
  		@student = Student.find(params[:id])
	end

 end