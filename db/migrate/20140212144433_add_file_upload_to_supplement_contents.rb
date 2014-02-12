class AddFileUploadToSupplementContents < ActiveRecord::Migration
  def change
    add_column :supplement_contents, :file_upload, :string
  end
end
