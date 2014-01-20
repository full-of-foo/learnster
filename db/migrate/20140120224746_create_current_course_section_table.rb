class CreateCurrentCourseSectionTable < ActiveRecord::Migration
  def change
    create_table :current_course_sections do |t|
      t.belongs_to :student, index: true
      t.belongs_to :course_section, index: true
      t.timestamps
    end
  end
end
