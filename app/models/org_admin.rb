class OrgAdmin < User

  	belongs_to :admin_for, class_name: "Organisation", foreign_key: "admin_for" 

  	def self.model_name
    	User.model_name
  	end

	def app_admin?
		false
	end

	def org_admin?
		true
	end

	def student?
		false
	end
	
	
end