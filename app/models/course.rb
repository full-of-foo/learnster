class Course < ActiveRecord::Base
  acts_as_xlsx

  belongs_to :organisation
  belongs_to :managed_by, class_name: "OrgAdmin", foreign_key: "managed_by"
  has_many :course_sections

  validates_presence_of :title, :description, :managed_by, :organisation_id, :identifier
  validates_uniqueness_of :title, :scope => [:organisation_id]

  generate_scopes

  def self.search_term(search, nested_org = nil, managed_by_id = nil)
    if not search.empty? and not nested_org and not managed_by_id
      self.title_matches("%#{search}%") | self.description_matches("%#{search}%")

    elsif not search.empty? and nested_org
      (self.title_matches("%#{search}%") | self.description_matches("%#{search}%")) & self
        .organisation_id_eq(nested_org.id)

    elsif not search.empty? and managed_by_id
      (self.title_matches("%#{search}%") | self.description_matches("%#{search}%")) & self
        .managed_by_eq(managed_by_id)

    elsif search.empty? and nested_org
      self.organisation_id_eq(nested_org.id)

    elsif search.empty? and managed_by_id
      self.managed_by_eq(managed_by_id)

    else
      self.all
    end
  end

end
