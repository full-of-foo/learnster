class LearningModule < ActiveRecord::Base
  acts_as_xlsx

  belongs_to :educator, class_name: "OrgAdmin", foreign_key: "educator_id"
  belongs_to :organisation

  has_many :section_modules
  has_many :course_sections, through: :section_modules

  validates_presence_of :title, :description, :educator, :organisation
  validates_uniqueness_of :title, scope: :organisation,
    message: "Module title already exists"

  def self.organisation_modules(organisation_id)
    Organisation.find(organisation_id).learning_modules
  end

  def self.course_modules(course_id)
    CourseSection.where(course_id: course_id).first.learning_modules
  end

end
