class CreateDeliverablesTable < ActiveRecord::Migration
  def change
    create_table :deliverables_tables do |t|
      t.string :title, index: true
      t.string :description
      t.datetime :due_date
      t.boolean :is_closed, default: false
      t.boolean :is_private, default: true

      t.timestamps
      t.belongs_to :module_supplement, index: true
    end
  end
end
