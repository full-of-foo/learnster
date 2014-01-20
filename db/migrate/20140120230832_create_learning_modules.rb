class CreateLearningModules < ActiveRecord::Migration
  def change
    create_table :learning_modules do |t|
      t.string :title
      t.string :description

      t.timestamps
    end
    add_column :learning_modules, :educator_id, :integer
    add_index :learning_modules, :educator_id

  end

end
