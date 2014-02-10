class DropSectionColumnFromLearningModules < ActiveRecord::Migration
  def change
    remove_index :learning_modules, :course_section_id
    remove_column :learning_modules, :course_section_id, :integer
  end
end
