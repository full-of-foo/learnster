class CreateSupplementContents < ActiveRecord::Migration
  def change
    create_table :supplement_contents do |t|
      t.string :title, index: true
      t.string :description

      t.timestamps
      t.belongs_to :module_supplement, index: true
    end
  end
end
