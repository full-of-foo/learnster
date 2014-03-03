class ContentUpload < SupplementContent
  mount_uploader :file_upload, FileUploader

  validates_presence_of :file_upload

end
