class AddStudentFkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :attending_orgs, :integer
  end
end
