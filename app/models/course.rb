class Course < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :managed_by, class_name: "OrgAdmin", foreign_key: "managed_by"
  has_many :course_sections

  validates_presence_of :title, :description, :managed_by, :organisation_id, :identifier
  validates_uniqueness_of :title, :scope => [:organisation_id]

end
