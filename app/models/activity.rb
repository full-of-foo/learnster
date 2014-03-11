class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :trackable, polymorphic: true

  before_create :add_custom_message
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

    ids = (course_section_ids | module_ids | course_ids | supplement_ids | content_ids)

    (Activity.trackable_id_in(ids) | Activity.user_id_eq(admin_id))
  end

  def self.student_activities(student_id)
    section_ids  = EnrolledCourseSection.where("student_id = ?", student_id)
      .select("enrolled_course_sections.course_section_id").to_a.map(&:course_section_id)
    module_ids = SectionModule.where(course_section_id: section_ids)
      .select("learning_module_id").to_a.map(&:learning_module_id)
    course_ids = CourseSection.id_in(section_ids)
      .select("course_sections.course_id").map(&:course_id)
    supplement_ids = module_ids.empty? ? [] : ModuleSupplement.where(learning_module_id: module_ids).ids
    content_ids    = supplement_ids.empty? ? [] : SupplementContent.where(module_supplement_id: supplement_ids).ids

      ids = (section_ids | module_ids | course_ids | supplement_ids | content_ids)

    (Activity.trackable_id_in(ids) | Activity.user_id_eq(student_id))
  end


  private

    def add_custom_message
      case
      when self.trackable.is_a?(Student), self.trackable.is_a?(OrgAdmin)
        self.message = user_activity_message
      when self.trackable.is_a?(WikiSubmission), self.trackable.is_a?(WikiContent)
        self.message = wiki_activity_message
      when self.trackable.is_a?(SubmissionUpload), self.trackable.is_a?(ContentUpload)
        self.message = content_activity_message
      when self.trackable.is_a?(CourseSection), self.trackable.is_a?(Course)
        self.message = course_activity_message
      when self.trackable.is_a?(LearningModule), self.trackable.is_a?(ModuleSupplement)
        self.message =  module_activity_message
      when self.trackable.is_a?(Deliverable)
        self.message =  deliverable_activity_message
      end
    end

    def user_activity_message
      actionString = self.action == "create" ? "created the account" : "updated the profile"
      className    = self.trackable_type.downcase

      "#{actionString} of the #{className} #{self.trackable.full_name}"
    end

    def wiki_activity_message
      actionString = self.action == "create" ? "created" : "updated"

      "#{actionString} a wiki"
    end

    def content_activity_message
      actionString = self.action == "create" ? "uploaded" : "updated"
      className    = self.trackable.is_a?(SubmissionUpload) ? "a submission" : "some module content"

      "#{actionString} #{className}"
    end

    def course_activity_message
      actionString = self.action == "create" ? "created" : "updated"
      className    = self.trackable.is_a?(Course) ? "the course" : "a course section"
      title        = self.trackable.is_a?(CourseSection) ? self.trackable.section : self.trackable.title

      "#{actionString} #{className} #{title}"
    end

    def module_activity_message
      actionString = self.action == "create" ? "created" : "updated"
      className    = self.trackable.is_a?(LearningModule) ? "the module" : "a module supplement named"
      title        = self.trackable.title

      "#{actionString} #{className} #{title}"
    end

    def deliverable_activity_message
      actionString = self.action == "create" ? "created" : "updated"
      className    = "the deliverable named"
      title        = self.trackable.title

      "#{actionString} #{className} #{title}"
    end


end
