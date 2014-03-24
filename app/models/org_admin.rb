class OrgAdmin < User
  extend Enumerize

  acts_as_xlsx

  belongs_to :admin_for, class_name: "Organisation", foreign_key: "admin_for"

  has_many :managed_courses, class_name: "Course", foreign_key: "managed_by"
  has_many :provisioned_courses, class_name: "CourseSection", foreign_key: "provisioned_by"
  has_many :learning_modules, class_name: "LearningModule", foreign_key: "educator_id"

  enumerize :role, in: [:account_manager, :module_manager, :course_manager], default: :module_manager

  ROLE_REGEX = /(^account_manager$)|(^module_manager$)|(^course_manager$)/
  validates :role, :format => { :with => ROLE_REGEX, message: "invalid role type" }, :allow_blank => true

  after_validation :remove_nonrequired_errors


  def self.model_name
    User.model_name
  end

  def self.student_admins(student_id)
    # TODO - better querying
    course_manager_ids = Course.student_courses(student_id).select("managed_by")
      .to_a.map(&:managed_by).map(&:id)

    student_section_ids  = EnrolledCourseSection.where("student_id = ?", student_id)
      .select("enrolled_course_sections.course_section_id").to_a.map(&:course_section_id)
    provisioner_ids = CourseSection.where(id: student_section_ids).select('provisioned_by')
      .map(&:provisioned_by).map(&:id)

    module_ids = SectionModule.where(course_section_id: student_section_ids)
      .select("learning_module_id").to_a.map(&:learning_module_id)
    educator_ids = LearningModule.where(id: module_ids).select("educator_id")
      .map(&:educator_id)

    admin_ids = (course_manager_ids | provisioner_ids | educator_ids)
    self.where(id: admin_ids)
  end

  def self.import_with_validation(file, admin_for, created_by)
    spreadsheet = open_spreadsheet(file)
    import_status_data = Hash.new
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      params = row.to_hash.slice "email", "first_name", "surname", "password"
      params['password_confirmation'] = params['password']
      params['created_by']            = created_by
      params['admin_for']             = admin_for
      params['role']                  = row['role']
      params['confirmed']             = true if row['role'] == "account_manager"

      params = params.merge is_active: false, last_login: Time.zone.now
      admin = OrgAdmin.new(params.symbolize_keys)

      import_status_data["Row #{i}"] = admin.save ? true : admin.errors
    end
    import_status_data
  end

  def self.search_term(search, nested_org = nil, from_role = nil, created_by_id = nil, student_id = nil)
    admins = nil
    if not search.empty? and not nested_org and not created_by_id and not student_id
      admins = self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")

    elsif not search.empty? and nested_org
      admins = (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")) & self.admin_for_eq(nested_org.id)

    elsif not search.empty? and created_by_id
      admins = (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")) & self.created_by_eq(created_by_id)

    elsif not search.empty? and student_id
      admins = (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")) & self.student_admins(student_id)

    elsif search.empty? and nested_org
      admins = self.admin_for_eq(nested_org.id)

    elsif search.empty? and created_by_id
      admins = self.created_by_eq(created_by_id)

    elsif search.empty? and student_id
      admins = self.student_admins(student_id)

    else
      admins = self.all
    end
    if from_role
        is_account_mgr_search = from_role == 'account_manager'
        is_course_mgr_search = from_role == 'course_manager'
        is_module_mgr_search = from_role == 'module_manager'
        admins = (admins & (self.search_role(from_role) | self.search_role("course_manager") | self
                    .search_role("account_manager"))) if is_module_mgr_search
        admins = (admins & (self.search_role(from_role) | self
                    .search_role("account_manager"))) if is_course_mgr_search
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

  def remove_nonrequired_errors
    role_errors = self.errors.to_hash.fetch(:role){{}}
    role_errors.delete_at(0) if role_errors[0] == "is not included in the list"
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
