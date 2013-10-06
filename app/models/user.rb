class User < ActiveRecord::Base
	authenticates_with_sorcery!
	belongs_to :created_by, class_name: "User", foreign_key: "created_by"
	has_many :users, class_name: "User", foreign_key: "created_by"

  	validates_uniqueness_of :email
  	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  	validates_presence_of :email, :first_name, :surname

	  validates :password, confirmation: true, length: { in: 6..20 }, :on => :create
  	validates :password_confirmation, presence: true, :on => :create

    def full_name
        "#{first_name} #{surname}"
    end
end
