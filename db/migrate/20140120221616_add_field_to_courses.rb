class AddFieldToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :description, :string
  end
end
