class RemoveUserIdFromOrganisation < ActiveRecord::Migration
  def change
    remove_column :organisations, :user_id, :integer
  end
end
