class CreateSubmissionsTable < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :notes
      t.string :type
      t.string :file_upload
      t.text :wiki_markup

      t.timestamps
      t.belongs_to :deliverable, index: true
      t.belongs_to :student, index: true
    end
  end
end
