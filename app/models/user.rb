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

  def self.search_range(months_ago, date_attr_key, nested_org = nil)
    date_attr_str = date_attr_key == :created_at ? "created_at" : "updated_at"
    (user_org_attr_str = self.name == "OrgAdmin" ? "admin_for" : "attending_org") if not nested_org.nil?

    if ["3", "6", "9", "12", "24", "36", "48", "60"].include? months_ago
      if nested_org.nil?
        (self.send("#{date_attr_str}_lteq", Time.zone.now) & self
          .send("#{date_attr_str}_gteq", Time.zone.now.ago((months_ago.to_i).months))) 
      else
        (self.send("#{date_attr_str}_lteq", Time.zone.now) & self
          .send("#{date_attr_str}_gteq", Time.zone.now.ago((months_ago.to_i).months)) & self
          .send("#{user_org_attr_str}_eq", nested_org.id)) 
      end
    end   
  end

  def self.authenticated_user(token, options = nil)
    keys = ApiKey.access_token_eq(token)
    keys.size > 0 ? keys.first.user : false 
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  private 

  def add_api_key
    key = ApiKey.create
    self.api_keys.push key
  end

end
