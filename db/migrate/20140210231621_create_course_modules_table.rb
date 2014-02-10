class CreateCourseModulesTable < ActiveRecord::Migration
  def change
    create_table :section_modules do |t|
      t.belongs_to :learning_module, index: true
      t.belongs_to :course_section, index: true
      t.timestamps
    end
  end
end
