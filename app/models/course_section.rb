class CourseSection < ActiveRecord::Base
  belongs_to :course
  belongs_to :provisioned_by, class_name: "OrgAdmin", foreign_key: "provisioned_by"
  has_many :learning_modules
  has_many :enrolled_course_sections

  validates_presence_of :section, :provisioned_by, :course_id
  validates_uniqueness_of :section, :scope => [:course_id]

end
