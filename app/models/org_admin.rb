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

  def self.import_with_validation(file, admin_for, created_by)
    spreadsheet = open_spreadsheet(file)
    import_status_data = Hash.new
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      params = row.to_hash.slice "email", "first_name", "surname", "password" 
      params['id'] = find_by_id(row["id"]) ? row["id"] : nil if row["id"]    
      params['password_confirmation'] = params['password']
      params['created_by'] = created_by
      params['admin_for'] = admin_for
      params = params.merge is_active: false, last_login: Time.zone.now

      admin = OrgAdmin.new(params.symbolize_keys)

      import_status_data["Row #{i}"] = admin.save ? true : admin.errors  
    end
    import_status_data
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