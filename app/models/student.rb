class Student < User

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