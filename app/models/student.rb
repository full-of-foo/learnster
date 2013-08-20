class Student < User

  	belongs_to :attending_org, class_name: "Organisation", foreign_key: "attending_org" 

  	def self.model_name
    	User.model_name
  	end

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