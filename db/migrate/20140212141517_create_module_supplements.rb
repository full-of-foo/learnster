class CreateModuleSupplements < ActiveRecord::Migration
  def change
    create_table :module_supplements do |t|
      t.string :title, index: true
      t.string :description

      t.timestamps
      t.belongs_to :learning_module, index: true
    end
  end

end
