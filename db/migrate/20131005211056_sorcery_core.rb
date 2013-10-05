class SorceryCore < ActiveRecord::Migration

    def change
		change_table :users do |t| 
			t.string :crypted_password, :default => nil
	      	t.string :salt,             :default => nil
	    end
    end
    
  end