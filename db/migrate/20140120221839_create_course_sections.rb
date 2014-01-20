class CreateCourseSections < ActiveRecord::Migration
  def change
    create_table :course_sections do |t|
      t.string :section

      t.timestamps
    end

    add_column :course_sections, :course_id, :integer
    add_index :course_sections, :course_id

    add_column :course_sections, :provisioned_by, :integer
    add_index :course_sections, :provisioned_by
  end
end
