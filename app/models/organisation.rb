class Organisation < ActiveRecord::Base
  
  belongs_to :created_by, class_name: "AppAdmin", foreign_key: "created_by"
  belongs_to :admin_for, class_name: "OrgAdmin", foreign_key: "admin_for"
  has_many :students, class_name: "Student", foreign_key: "attending_org" 

end
