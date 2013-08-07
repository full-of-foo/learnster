class OrgAdmin < User

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