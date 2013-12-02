class Student < User
  acts_as_xlsx

  belongs_to :attending_org, class_name: "Organisation", foreign_key: "attending_org" 
  validates_presence_of :attending_org

  def org_id
    self.attending_org ? self.attending_org.id : nil 
  end

  def org_title
    self.attending_org ? self.attending_org.title : nil 
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

  def self.import_with_validation(file, attending_organisation, created_by)
    spreadsheet = open_spreadsheet(file)
    import_status_data = Hash.new
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      params = row.to_hash.slice "email", "first_name", "surname", "password" 
      params['id'] = find_by_id(row["id"]) ? row["id"] : nil if row["id"]    
      params['password_confirmation'] = params['password']
      params['created_by'] = created_by
      params['attending_org'] = attending_organisation
      params = params.merge is_active: false, last_login: Time.zone.now

      student = Student.new(params.symbolize_keys)

      import_status_data["Row #{i}"] = student.save ? true : student.errors  
    end
    import_status_data
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
end