class SupplementContent < ActiveRecord::Base
  belongs_to :module_supplement
  mount_uploader :file_upload, FileUploader

  validates_presence_of :module_supplement, :title, :file_upload

  def self.organisation_contents(organisation_id)
    self.joins(module_supplement: [learning_module: :organisation])
      .where("learning_modules.organisation_id = ?", organisation_id)
  end

  def self.educator_contents(educator_id)
    self.joins(module_supplement: :learning_module)
      .where("learning_modules.educator_id = ?", educator_id)
  end
end
