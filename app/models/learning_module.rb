class LearningModule < ActiveRecord::Base
  belongs_to :educator_id, class_name: "OrgAdmin", foreign_key: "educator_id"
  belongs_to :course_section
end
