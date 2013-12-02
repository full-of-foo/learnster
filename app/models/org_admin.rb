class OrgAdmin < User
	acts_as_xlsx
	
	validates_presence_of :admin_for
  belongs_to :admin_for, class_name: "Organisation", foreign_key: "admin_for" 
  
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

  def self.search_term(search, nested_org = nil)
    if not search.empty? and not nested_org
      self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%")
    elsif not search.empty? and nested_org 
      (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%")) & self.admin_for_eq(nested_org.id)
    elsif search.empty? and nested_org
      self.admin_for_eq(nested_org.id)
    else
      self.all
    end
  end
	
	
end