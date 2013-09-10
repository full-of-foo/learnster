class User < ActiveRecord::Base

	belongs_to :created_by, class_name: "User", foreign_key: "created_by"
	has_many :users, class_name: "User", foreign_key: "created_by" 

  	validates_uniqueness_of :email
  	validates_presence_of :email, :first_name, :surname
  	validates_presence_of :attending_org, :created_by, unless: proc { new_record? }

    def full_name
        "#{first_name} #{surname}"
    end

end
