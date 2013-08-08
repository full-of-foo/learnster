class AddForeignKeyToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :created_by, :integer
  end
end
