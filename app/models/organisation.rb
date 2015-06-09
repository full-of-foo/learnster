class Organisation < ActiveRecord::Base
  acts_as_xlsx columns: [:title, :description, :created_at] if ActiveRecord::Base.connection.tables.any?

  belongs_to :created_by, class_name: "OrgAdmin", foreign_key: "created_by"

  has_many :admins, class_name: "OrgAdmin", foreign_key: "admin_for", :dependent => :destroy
  has_many :students, class_name: "Student", foreign_key: "attending_org", :dependent => :destroy
  has_many :courses, :dependent => :destroy
  has_many :learning_modules, :dependent => :destroy

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

  def has_section?(section_id)
    !CourseSection.joins(course: :organisation)
      .where("courses.organisation_id = ? AND course_sections.id = ?", self.id, section_id).empty?
  end

end
