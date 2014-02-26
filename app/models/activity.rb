class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  generate_scopes

  def self.organisation_activities(organisation_id)
    (Activity.joins(:user)
      .where("users.type = ? AND users.attending_org = ?", "Student", organisation_id) |
        Activity.joins(:user)
          .where("users.type = ? AND users.admin_for = ?", "OrgAdmin", organisation_id))
  end

  def self.manager_activities(admin_id)
    admin              = OrgAdmin.find(admin_id)

    course_ids         = admin.managed_courses.ids
    course_section_ids = course_ids.empty? ? [] : CourseSection.where(course_id: course_ids).ids
    module_ids         = admin.learning_modules.ids
    supplement_ids     = module_ids.empty? ? [] : ModuleSupplement.where(learning_module_id: module_ids).ids
    content_ids        = supplement_ids.empty? ? [] : SupplementContent.where(module_supplement_id: supplement_ids).ids

    ids = course_ids.concat(course_section_ids).concat(module_ids)
      .concat(supplement_ids).concat(content_ids).uniq

    (Activity.trackable_id_in(ids) | Activity.user_id_eq(admin_id))
  end


end
