class User < ActiveRecord::Base
	authenticates_with_sorcery!
	belongs_to :created_by, class_name: "User", foreign_key: "created_by"
	has_many :users, class_name: "User", foreign_key: "created_by"

  	validates_uniqueness_of :email
  	validates_presence_of :email, :first_name, :surname
	validates_confirmation_of :password
	validates_presence_of :password, :on => :create
  

    def full_name
        "#{first_name} #{surname}"
    end
end
