class OrgAdmin < User
	include PublicActivity::Model
	
	tracked owner: ->(controller, model) { controller && controller.current_user }
	acts_as_xlsx
	
	validates_presence_of :admin_for
  	belongs_to :admin_for, class_name: "Organisation", foreign_key: "admin_for" 

  	searchable do
		text :first_name, :boost => 2
		text :surname, :boost => 5 
		text :email
		date :created_at
		date :updated_at
		text :admin_for do
			admin_for.title
		end
		integer :org_id do
			admin_for.id
		end
	end

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