class AddSectionColumnToLearningModules < ActiveRecord::Migration
  def change
    add_column :learning_modules, :course_section_id, :integer
    add_index :learning_modules, :course_section_id
  end
end
