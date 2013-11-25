class OrgAdmin < User
	acts_as_xlsx
	
	validates_presence_of :admin_for
  belongs_to :admin_for, class_name: "Organisation", foreign_key: "admin_for" 

  searchable do
		text :first_name, :boost => 2
		text :surname, :boost => 5 
		text :email
		date :created_at
		date :updated_at
 		integer :org_id
    text :org_title, :boost => 2
  end

  def org_id
    self.admin_for ? self.admin_for.id : nil 
  end

  def org_title
    self.admin_for ? self.admin_for.title : nil 
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