class AddForeignKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :created_by, :integer
  end
end
