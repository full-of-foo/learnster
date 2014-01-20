class Course < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :managed_by, class_name: "OrgAdmin", foreign_key: "managed_by"
  has_many :course_sections

end
