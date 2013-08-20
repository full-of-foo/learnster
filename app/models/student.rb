class Student < User

  	belongs_to :attending_org, class_name: "Organisation", foreign_key: "attending_org" 


	def app_admin?
		false
	end

	def org_admin?
		false
	end

	def student?
		true
	end
	
end