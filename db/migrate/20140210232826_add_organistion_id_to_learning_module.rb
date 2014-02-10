class AddOrganistionIdToLearningModule < ActiveRecord::Migration
  def change
    add_column :learning_modules, :organisation_id, :integer
    add_index :learning_modules, :organisation_id
  end
end
