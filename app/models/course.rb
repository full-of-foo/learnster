class Course < ActiveRecord::Base
  before_destroy :untrack_self
  acts_as_xlsx columns: [:title, :description, :identifier, :'managed_by.full_name', :created_at] if ActiveRecord::Base.connection.tables.any?

  belongs_to :organisation
  belongs_to :managed_by, class_name: "OrgAdmin", foreign_key: "managed_by"
  has_many :course_sections, :dependent => :destroy

  validates_presence_of :title, :description, :managed_by, :organisation_id, :identifier
  validates_uniqueness_of :title, :scope => [:organisation_id]

  generate_scopes

  def self.student_courses(student_id)
    section_ids  = EnrolledCourseSection.where("student_id = ?", student_id)
      .select("enrolled_course_sections.course_section_id").to_a.map(&:course_section_id)
    course_ids = CourseSection.id_in(section_ids)
      .select("course_sections.course_id").map(&:course_id)

    self.id_in course_ids
  end

  def self.search_term(search, nested_org = nil, managed_by_id = nil, student_id = nil)
    if not search.empty? and not nested_org and not managed_by_id and not student_id
      self.title_matches("%#{search}%") | self.description_matches("%#{search}%")

    elsif not search.empty? and nested_org
      (self.title_matches("%#{search}%") | self.description_matches("%#{search}%")) & self
        .organisation_id_eq(nested_org.id)

    elsif not search.empty? and managed_by_id
      (self.title_matches("%#{search}%") | self.description_matches("%#{search}%")) & self
        .managed_by_eq(managed_by_id)

    elsif not search.empty? and student_id
      (self.title_matches("%#{search}%") | self.description_matches("%#{search}%")) & self
        .student_courses(student_id)

    elsif search.empty? and nested_org
      self.organisation_id_eq(nested_org.id)

    elsif search.empty? and managed_by_id
      self.managed_by_eq(managed_by_id)

    elsif search.empty? and student_id
      self.student_courses(student_id)

    else
      self.all
    end
  end

  private

    def untrack_self
      Activity.delete_all(trackable_id: self.id)
    end

end
