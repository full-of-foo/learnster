class AppAdmin < User

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