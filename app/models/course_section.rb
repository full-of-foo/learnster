class CourseSection < ActiveRecord::Base
  before_destroy :untrack_self
  acts_as_xlsx

  belongs_to :course
  belongs_to :provisioned_by, class_name: "OrgAdmin", foreign_key: "provisioned_by"

  has_many :enrolled_course_sections, :dependent => :destroy
  has_many :students, through: :enrolled_course_sections
  has_many :section_modules, :dependent => :destroy
  has_many :learning_modules, through: :section_modules

  validates_presence_of :section, :provisioned_by, :course_id
  validates_uniqueness_of :section, :scope => [:course_id]

  generate_scopes

  def self.organisation_course_sections(organisation_id, course_id = nil)
    if course_id.nil?
      self.joins(:course => :organisation).where("courses.organisation_id = ?", organisation_id)
    else
      Course.find(course_id).course_sections
    end
  end

  private

    def untrack_self
      Activity.delete_all(trackable_id: self.id) 
    end

end
