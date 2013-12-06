class User < ActiveRecord::Base
  has_secure_password
  before_create :add_api_key
  
  belongs_to :created_by, class_name: "User", foreign_key: "created_by"
  has_many :users, class_name: "User", foreign_key: "created_by"
  has_many :activities
  has_many :api_keys

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

  def self.search_range(months_ago, date_attr_key)
    date_attr_str = date_attr_key == :created_at ? "created_at" : "updated_at"
    if ["3", "6", "9", "12", "24", "36", "48", "60"].include? months_ago
      (self.send("#{date_attr_str}_lteq", Time.zone.now) & self.send("#{date_attr_str}_gteq", Time.zone.now.ago((months_ago.to_i).months))) 
    end   
  end

  def self.authenticated_user(token, options = nil)
    keys = ApiKey.access_token_eq(token)
    keys.size > 0 ? keys.first.user : false 
  end

  private 

  def add_api_key
    key = ApiKey.create
    self.api_keys.push key
  end

end
