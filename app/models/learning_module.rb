class LearningModule < ActiveRecord::Base
  acts_as_xlsx

  belongs_to :educator, class_name: "OrgAdmin", foreign_key: "educator_id"
  belongs_to :organisation

  has_many :section_modules
  has_many :course_sections, through: :section_modules

  validates_presence_of :title, :description, :educator, :organisation
  validates_uniqueness_of :title, scope: :organisation,
    message: "Module title already exists"

  generate_scopes


  def self.organisation_modules(organisation_id)
    Organisation.find(organisation_id).learning_modules
  end

  def self.course_modules(course_id)
    CourseSection.where(course_id: course_id).first.learning_modules
  end

  def self.find_by_org_and_title(organisation_id, title)
    self.where(organisation_id: organisation_id, title: title).first
  end

  def self.search_term(search, nested_org = nil)
    if not search.empty? and not nested_org
      self.title_matches("%#{search}%") | self.description_matches("%#{search}%")
    elsif not search.empty? and nested_org
      (self.title_matches("%#{search}%") | self.description_matches("%#{search}%")) & self
        .organisation_id_eq(nested_org.id)
    elsif search.empty? and nested_org
      self.organisation_id_eq(nested_org.id)
    else
      self.all
    end
  end

  def shared_on_course_section_count
    SectionModule.where(learning_module: self).count
  end

end
