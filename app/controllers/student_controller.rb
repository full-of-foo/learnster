class StudentController < ApplicationController
    respond_to :json
    before_filter :find_org


    def index
    	if search_request?
	    	@search = Student.search do
	    		fulltext params[:search]
	    		with(:org_id).equal_to(params[:organisation_id]) if nested_org_request?
	    		paginate :page => 1, :per_page => 10000
	    	end
	        return (@students = @search.results)
    	end
    	
    	@students = nested_org_request? ? @org.students() : Student.all()

    	if xlsx_request? 
    		respond_to do |format|
	  			format.xlsx {
	            	send_data @students.to_xlsx.to_stream.read, :filename => 'students.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
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
		if @student.update permitted_params.user_params
			render "student/show"
		else
			respond_with @student
		end
	end

	def create
		@student = Student.new
		params = permitted_params.user_params().merge default_attrs
		puts "Merged params: #{params}"
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
