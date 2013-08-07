class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :surname
      t.string :type
      t.timestamp :last_login
      t.boolean :is_active

      t.timestamps
    end
  end
end
