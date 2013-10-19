class Student < User
	acts_as_xlsx

  	belongs_to :attending_org, class_name: "Organisation", foreign_key: "attending_org" 
	validates_presence_of :attending_org

	searchable do
		text :first_name, :boost => 2
		text :surname, :boost => 5 
		text :email
		date :created_at
		text :attending_org do
			attending_org.title
		end
		integer :org_id do
			attending_org.id
		end
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