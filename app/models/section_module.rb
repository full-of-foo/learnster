class SectionModule < ActiveRecord::Base
  belongs_to :learning_module
  belongs_to :course_section

  validates_presence_of :learning_module, :course_section
  validates_uniqueness_of :learning_module, scope: :course_section,
    message: "module already on section"

end
