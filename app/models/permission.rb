class Permission < Struct.new(:user)

	def allow?(controller, action, params)
		return true if controller.end_with?("sessions")
		return true if controller.end_with?("application") && action == "index"
		if user

			return true if user.app_admin?
			if user.org_admin?
				@org = user.admin_for
				return true if controller.end_with?("student")					  && action == "create"
				return true if controller.end_with?("org_admin")				  && action == "create"

				return true if organisation_request?(controller, params)    	  && action.in?(%w[show edit])
				return true if organisation_students_request?(controller, params) && action.in?(%w[index show])
				return true if fellow_admins_request?(controller, params)    	  && action.in?(%w[index show])

				return true if fellow_admin_request?(controller, params)    	  && action.in?(%w[show edit])
				return true if organisation_student_request?(controller, params)  && action.in?(%w[show edit update destroy])
			end
			if user.student?

			end
		end
		false
	end


	private

		def organisation_request?(controller, params)
			controller.end_with?("organisation") && params[:id].to_i == @org.id
		end


		def organisation_students_request?(controller, params)
			controller.end_with?("student") && params[:organisation_id].to_i == @org.id
		end

		def organisation_student_request?(controller, params)
			controller.end_with?("student") && @org.students.exists?(params[:id])
		end

		def fellow_admins_request?(controller, params)
			controller.end_with?("org_admin") && params[:organisation_id].to_i == @org.id
		end

		def fellow_admin_request?(controller, params)
			controller.end_with?("org_admin") && @org.admins.exists?(params[:id])
		end

end