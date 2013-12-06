class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token, null: false
      t.boolean :active, null: false, default: true
      t.string :expires_at
      t.references :user, index: true

      t.timestamps
    end
  end

end
