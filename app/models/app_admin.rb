class AppAdmin < User
	include PublicActivity::Model
	
	tracked owner: ->(controller, model) { controller && controller.current_user }

	def self.model_name
    	User.model_name
  	end

	def app_admin?
		true
	end

	def org_admin?
		false
	end

	def student?
		false
	end
	
end