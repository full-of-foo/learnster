class AddCoursesToOrg < ActiveRecord::Migration

   def change
    add_column :courses, :organisation_id, :integer
    add_index :courses, :organisation_id
  end
end
