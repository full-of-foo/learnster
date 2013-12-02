class Organisation < ActiveRecord::Base
  acts_as_xlsx
  
  belongs_to :created_by, class_name: "OrgAdmin", foreign_key: "created_by"
  has_many :admins, class_name: "OrgAdmin", foreign_key: "admin_for"
  has_many :students, class_name: "Student", foreign_key: "attending_org"

  validates_uniqueness_of :title
  validates_presence_of :title, :description

  generate_scopes


  def self.search_term(search)
    if not search.empty?
      self.title_matches("%#{search}%") | self.description_matches("%#{search}%")
    else
      self.all
    end
  end

end
