class Student < User
  acts_as_xlsx columns: [:first_name, :surname, :email, :created_at]

  belongs_to :attending_org, class_name: "Organisation", foreign_key: "attending_org"
  has_many :enrolled_course_sections, :dependent => :destroy
  has_many :course_sections, through: :enrolled_course_sections
  has_many :submissions, :dependent => :destroy

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

  def self.coursemates(student_id)
    section_ids  = EnrolledCourseSection.where("student_id = ?", student_id)
      .select("enrolled_course_sections.course_section_id").to_a.map(&:course_section_id)
    student_ids = (EnrolledCourseSection.where(course_section_id: section_ids)
                    .select('student_id').to_a.map(&:student_id)).uniq

    self.where(id: student_ids)
  end

  def self.module_students(module_id)
    section_ids = SectionModule.where(learning_module_id: module_id)
      .select("section_modules.course_section_id").to_a.map(&:course_section_id)
    student_ids = EnrolledCourseSection.where(course_section_id: section_ids)
      .select("student_id").to_a.map(&:student_id)

    self.where(id: student_ids)
  end

  def self.import_with_validation(file, attending_organisation, created_by)
    spreadsheet = open_spreadsheet(file)
    import_status_data = Hash.new
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      params = row.to_hash.slice "email", "first_name", "surname", "password"
      params['password_confirmation'] = params['password']
      params['created_by'] = created_by
      params['attending_org'] = attending_organisation
      params = params.merge is_active: false, last_login: Time.zone.now

      student = Student.new(params.symbolize_keys)

      import_status_data["Row #{i}"] = student.save ? true : student.errors
    end
    import_status_data
  end

  def self.search_term(search, nested_org = nil, created_by_id = nil, student_id = nil)
    if not search.empty? and not nested_org and not created_by_id and not student_id
      self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")

    elsif not search.empty? and nested_org
      (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")) & self.attending_org_eq(nested_org.id)

    elsif not search.empty? and created_by_id
      (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")) & self.created_by_eq(created_by_id)

    elsif not search.empty? and student_id
      (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%") | self
        .email_matches("%#{search}%")) & self.coursemates(student_id)

    elsif search.empty? and nested_org
      self.attending_org_eq(nested_org.id)

    elsif search.empty? and created_by_id
      self.created_by_eq(created_by_id)

    elsif search.empty? and student_id
      self.coursemates(student_id)

    else
      self.all
    end
  end

end
