class AddManagersToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :managed_by, :integer
    add_index :courses, :managed_by
  end
end
