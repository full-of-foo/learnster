class SupplementContent < ActiveRecord::Base
  belongs_to :module_supplement
  mount_uploader :file_upload, FileUploader

  validates_presence_of :module_supplement, :title, :file_upload
end
