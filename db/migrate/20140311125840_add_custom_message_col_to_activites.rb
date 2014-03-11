class AddCustomMessageColToActivites < ActiveRecord::Migration
  def change
    add_column :activities, :message, :string
  end
end
