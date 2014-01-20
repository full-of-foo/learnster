class CourseSection < ActiveRecord::Base
  belongs_to :course
  belongs_to :provisioned_by, class_name: "OrgAdmin", foreign_key: "provisioned_by"
  has_many :learning_modules
end
