class LearningModule < ActiveRecord::Base
  belongs_to :educator, class_name: "OrgAdmin", foreign_key: "educator_id"
  belongs_to :course_section

  validates_presence_of :title, :description, :educator, :course_section
  validates_uniqueness_of :title, scope: :course_section,
    message: "Module title already exists in this section"

end
