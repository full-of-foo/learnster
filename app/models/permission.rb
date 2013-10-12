class Permission < Struct.new(:user)

	def allow?(controller, action, params)
		return true if controller.end_with?("sessions")
		return true if controller.end_with?("application") && action == "index"
		if user
			return true if user.app_admin?
			if user.org_admin?
				return true if organisation_students_request?(controller, params) && action.in?("%w[index show]")
				return true if admin_org_request?(controller, params) && action.in?(%w[show edit])
				return true if controller.end_with?("org_admin") && action.in?(%w[index show edit])
			end
		end
		false
	end


	private

		def organisation_students_request?(controller, params)
			controller.end_with?("student") && !!params[:organisation_id] 
		end

		def admin_org_request?(controller, params)
			controller.end_with?("organisation") && params[:organisation_id] == user.admin_for.id
		end

end