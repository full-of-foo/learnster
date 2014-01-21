class CreateCurrentCourseSectionTable < ActiveRecord::Migration
  def change
    create_table :enrolled_course_sections do |t|
      t.belongs_to :student, index: true
      t.belongs_to :course_section, index: true
      t.timestamps
    end

    add_column :enrolled_course_sections, :is_active, :boolean
  end
end
