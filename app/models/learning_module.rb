class LearningModule < ActiveRecord::Base
  acts_as_xlsx
  before_destroy :untrack_self

  belongs_to :educator, class_name: "OrgAdmin", foreign_key: "educator_id"
  belongs_to :organisation

  has_many :section_modules, :dependent => :destroy
  has_many :course_sections, through: :section_modules
  has_many :module_supplements, :dependent => :destroy

  validates_presence_of :title, :description, :educator, :organisation
  validates_uniqueness_of :title, scope: :organisation,
    message: "module title already exists"

  generate_scopes


  def self.organisation_modules(organisation_id)
    Organisation.find(organisation_id).learning_modules
  end

  def self.course_modules(course_id)
    CourseSection.where(course_id: course_id).first.learning_modules
  end

  def self.student_modules(student_id)
    section_ids  = EnrolledCourseSection.where("student_id = ?", student_id)
      .select("enrolled_course_sections.course_section_id").to_a.map(&:course_section_id)
    module_ids = SectionModule.where(course_section_id: section_ids)
      .select("learning_module_id").to_a.map(&:learning_module_id)

    self.where(id: module_ids)
  end

  def self.find_by_org_and_title(organisation_id, title)
    self.where(organisation_id: organisation_id, title: title).first
  end

  def self.search_term(search, nested_org = nil, educator_id = nil, student_id = nil)
    if not search.empty? and not nested_org and not educator_id and not student_id
      self.title_matches("%#{search}%") | self.description_matches("%#{search}%")

    elsif not search.empty? and nested_org
      (self.title_matches("%#{search}%") | self.description_matches("%#{search}%")) & self
        .organisation_id_eq(nested_org.id)

    elsif not search.empty? and educator_id
      (self.title_matches("%#{search}%") | self.description_matches("%#{search}%")) & self
        .educator_id_eq(educator_id)

    elsif not search.empty? and student_id
      (self.title_matches("%#{search}%") | self.description_matches("%#{search}%")) & self
        .student_modules(student_id)

    elsif search.empty? and nested_org
      self.organisation_id_eq(nested_org.id)

    elsif search.empty? and educator_id
      self.educator_id_eq(educator_id)

    elsif search.empty? and student_id
      self.student_modules(student_id)

    else
      self.all
    end
  end

  def shared_on_course_section_count
    SectionModule.where(learning_module: self).count
  end

  def student_count
    Student.module_students(self.id).count
  end

  private

    def untrack_self
      Activity.delete_all(trackable_id: self.id) 
    end

end
