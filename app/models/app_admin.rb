class AppAdmin < User

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