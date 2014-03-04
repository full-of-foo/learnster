class Deliverable < ActiveRecord::Base
  belongs_to :module_supplement
  validates_presence_of :module_supplement, :title, :due_date


  def self.organisation_deliverables(organisation_id)
    self.joins(module_supplement: [learning_module: :organisation])
      .where("learning_modules.organisation_id = ?", organisation_id)
  end

  def self.educator_deliverables(educator_id)
    self.joins(module_supplement: :learning_module)
      .where("learning_modules.educator_id = ?", educator_id)
  end

  def self.student_deliverables(student_id)
    section_ids  = EnrolledCourseSection.where("student_id = ?", student_id)
      .select("enrolled_course_sections.course_section_id").to_a.map(&:course_section_id)
    module_ids = SectionModule.where(course_section_id: section_ids)
      .select("learning_module_id").to_a.map(&:learning_module_id)

    self.joins(module_supplement: :learning_module)
      .where("module_supplements.learning_module_id IN (?)", module_ids)
  end
end
