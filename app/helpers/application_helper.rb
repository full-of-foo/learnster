module ApplicationHelper

	def permitted_params(params)
		@permitted_params ||= PermittedParams.new(params, current_user)
	end

	def not_found
		raise ActionController::RoutingError.new('Not Found')
	end
end
