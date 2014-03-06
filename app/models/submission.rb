class Submission < ActiveRecord::Base
  belongs_to :deliverable
  belongs_to :student

  validates_presence_of :deliverable, :student

  def self.supplement_submissions(supplement_id)
    self.joins(:deliverable)
      .where("deliverables.module_supplement_id = ?", supplement_id)
  end

  def self.module_submissions(module_id)
    self.joins(deliverable: :module_supplement)
      .where("module_supplements.learning_module_id = ?", module_id)
  end
end
