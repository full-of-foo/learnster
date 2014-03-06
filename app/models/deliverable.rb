class Deliverable < ActiveRecord::Base
  belongs_to :module_supplement
  has_many :submissions

  validates_presence_of :module_supplement, :title, :due_date


  def self.organisation_deliverables(organisation_id)
    self.joins(module_supplement: [learning_module: :organisation])
      .where("learning_modules.organisation_id = ?", organisation_id)
  end

  def self.educator_deliverables(educator_id)
    self.joins(module_supplement: :learning_module)
      .where("learning_modules.educator_id = ?", educator_id)
  end

  def self.student_deliverables(student_id, module_supplement_id = nil, deliverable_id = nil)
    section_ids  = EnrolledCourseSection.where("student_id = ?", student_id)
      .select("enrolled_course_sections.course_section_id").to_a.map(&:course_section_id)
    module_ids = SectionModule.where(course_section_id: section_ids)
      .select("learning_module_id").to_a.map(&:learning_module_id)

    if module_supplement_id
      self.joins(module_supplement: :learning_module)
        .where("module_supplements.learning_module_id IN (?) AND module_supplements.id \
               = ?", module_ids, module_supplement_id)
    elsif deliverable_id
      self.joins(module_supplement: :learning_module)
        .where("module_supplements.learning_module_id IN (?) AND deliverables.id \
               = ?", module_ids, deliverable_id)
    else
      self.joins(module_supplement: :learning_module)
        .where("module_supplements.learning_module_id IN (?)", module_ids)
    end
  end

  def unique_student_submission_count
    self.submissions.select("DISTINCT student_id").count
  end
end
