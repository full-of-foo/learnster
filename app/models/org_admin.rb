class OrgAdmin < User

  	has_many :organisations, class_name: "Organisation", foreign_key: "admin_for" 

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