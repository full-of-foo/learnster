class AddCourseIdentifierColumn < ActiveRecord::Migration
  def change
    add_column :courses, :identifier, :string
    add_index :courses, :identifier
  end
end
