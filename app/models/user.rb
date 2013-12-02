class User < ActiveRecord::Base
	authenticates_with_sorcery!
	belongs_to :created_by, class_name: "User", foreign_key: "created_by"
	has_many :users, class_name: "User", foreign_key: "created_by"
  has_many :activities

	validates_uniqueness_of :email
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates_presence_of :email, :first_name, :surname

  validates :password, confirmation: true, length: { in: 6..20 }, :on => :create
	validates :password_confirmation, presence: true, :on => :create

	validates :password, confirmation: true, length: { in: 6..20 }, :allow_blank => true, :on => :update
	validates :password_confirmation, presence: true, :allow_blank => true, :on => :update

  generate_scopes

  def full_name
      "#{first_name} #{surname}"
  end

  def self.search_term(search, nested_org = nil)
    if search and not nested_org
      self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%")
    elsif search and nested_org 
      (self.first_name_matches("%#{search}%") | self.surname_matches("%#{search}%")) & self.attending_org_eq(nested_org.id)
    else
      self.all
    end
  end

end
