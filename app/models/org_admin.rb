class OrgAdmin < User
  extend Enumerize

  acts_as_xlsx

  belongs_to :admin_for, class_name: "Organisation", foreign_key: "admin_for"

  has_many :managed_courses, class_name: "Course", foreign_key: "managed_by"
  has_many :provisioned_courses, class_name: "CourseSection", foreign_key: "provisioned_by"
  has_many :learning_modules, class_name: "LearningModule", foreign_key: "educator_id"

  enumerize :role, in: [:account_manager, :course_manager, :module_manager], default: :module_manager


  def self.model_name
    User.model_name
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

  def self.search_term(search, nested_org = nil, from_role = nil, created_by_id = nil)
    admins = nil
    if not search.empty? and not nested_org and not created_by_id
      admins = self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")

    elsif not search.empty? and nested_org
      admins = (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")) & self.admin_for_eq(nested_org.id)

    elsif not search.empty? and created_by_id
      admins = (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")) & self.created_by_eq(created_by_id)

    elsif search.empty? and nested_org
      admins = self.admin_for_eq(nested_org.id)

    elsif search.empty? and created_by_id
      admins = self.created_by_eq(created_by_id)

    else
      admins = self.all
    end
    if from_role
        is_account_mgr_search = from_role == 'account_manager'
        is_course_mgr_search = from_role == 'course_manager'
        is_module_mgr_search = from_role == 'module_manager'
        admins = (admins & (self.search_role(from_role) | self.search_role("course_manager") | self.search_role("account_manager"))) if is_module_mgr_search
        admins = (admins & (self.search_role(from_role) | self.search_role("account_manager"))) if is_course_mgr_search
        admins = (admins & (self.search_role(from_role))) if is_account_mgr_search
    end
    admins
  end

  def self.search_role(role)
    is_course_mgr_search = role == 'course_manager'
    is_account_mgr_search = role == 'account_manager'
    is_module_mgr_search = role == 'module_manager'
    is_valid_role = is_course_mgr_search || is_account_mgr_search || is_module_mgr_search

    if is_valid_role
      self.role_eq role
    end
  end

  def self.deliver_confirmation_mail(id, confirm_url)
    find(id).deliver_confirmation_mail(confirm_url)
  end

  def deliver_confirmation_mail(confirm_url)
    UserMailer.signup_confirmation(self, confirm_url).deliver
    logger.info "Sending confirm email for user[id:#{self.id}, \
    email:'#{self.full_name}']; confirm url: #{confirm_url}"
  end

  def created_students
    Student.where(created_by: self.id)
  end

  def created_admins
    OrgAdmin.where(created_by: self.id)
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

  def org_id
    self.admin_for ? self.admin_for.id : nil
  end

  def org_title
    self.admin_for ? self.admin_for.title : nil
  end

end
