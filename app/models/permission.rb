class Permission < Struct.new(:user)

  def allow?(controller, action, params)
    return true if controller.end_with?("sessions")
    return true if controller.end_with?("application") && action == "index"
    if user
      @user = user
      return true if user.app_admin?
      account_controllers = %w[course learning_module wiki_content content_upload
        enrolled_course_section /course_section section_module module_supplement
        deliverable supplement_content /submission submission_upload wiki_submission]

      return true if update_account_request?(controller, action, params)

      if user.org_admin?
        @org = user.admin_for

        if action.in?(%w[index show])
          return true if organisation_students_request?(controller, params)
          return true if fellow_admins_request?(controller, params)
          return true if organisation_activity_request?(controller, params)
          return true if students_owned?(controller, params)
          return true if my_organisation_request?(controller, params)
          return true if fellow_admin_request?(controller, params)
          return true if organisation_student_request?(controller, params)
          return true if section_students_request?(controller, params)
        end

        if action.in?(%w[update destroy])
          return true if student_is_owned?(controller, params)
          return true if admin_is_owned?(controller, params)
        end

        if user.role.account_manager?
          return true if create_user_request?(controller, action)
          return true if my_organisation_import_request?(controller, params, action)

          account_controllers.each do |controller_name|
            return true if crud_on_controller?(controller_name, controller, action)
          end
        end

        if user.role.course_manager?
          account_controllers.each do |controller_name|
            return true if reads_on_controller?(controller_name, controller, action)
          end

          if course_related_controller_request?(controller)
            @admin_modules = user.learning_modules
            return true if my_supplement_updates_and_creates?(controller, action, params)
            return true if admin_deliverable_or_content_updates_and_creates?(controller, action, params)
            return true if my_module_updates?(controller, action, params)
            return true if create_module_request?(controller, action, params)

            @admin_courses = user.managed_courses
            return true if my_course_section_updates_and_creates?(controller, action, params)
            return true if my_section_module_updates_and_creates?(controller, action, params)
            return true if my_student_enrollment_cruds?(controller, action, params)
          end
        end

        if user.role.module_manager?
          account_controllers.each do |controller_name|
            return true if reads_on_controller?(controller_name, controller, action)
          end

          if course_related_controller_request?(controller)
            @admin_modules = user.learning_modules
            return true if my_supplement_updates_and_creates?(controller, action, params)
            return true if admin_deliverable_or_content_updates_and_creates?(controller, action, params)
            return true if my_module_updates?(controller, action, params)
            return true if create_module_request?(controller, action, params)
          end

        end

      end

      if user.student?
        @org = user.attending_org

        account_controllers.each do |controller_name|
            return true if reads_on_controller?(controller_name, controller, action)
        end

        if action.in?(%w[index show])
          return true if student_self_request?(controller, params)
          return true if organisation_students_request?(controller, params)
          return true if organisation_activity_request?(controller, params)
          return true if my_organisation_request?(controller, params)
          return true if fellow_admin_request?(controller, params)
          return true if organisation_student_request?(controller, params)
          return true if section_students_request?(controller, params)
        end

        return true if student_admins_request?(controller, action, params)
        return true if student_activity_request?(controller, action, params)
        return true if student_submission_updatable?(controller, action, params)
        @student_modules = LearningModule.student_modules(user.id)
        return true if student_submission_creatable?(controller, action, params)
      end
    end

    return false
  end


  private

    def nested_org_request?(organisation_id)
      organisation_id.to_i == @org.id
    end

    def my_organisation_request?(controller, params)
      controller.end_with?("organisation") && nested_org_request?(params[:id])
    end

    def my_organisation_import_request?(controller, params, action)
      student_import = controller.end_with?("student") && action == "import"
      admin_import = controller.end_with?("org_admin") && action == "import"

      (student_import || admin_import) && nested_org_request?(params[:organisation_id])
    end

    def create_user_request?(controller, action)
      is_create_student = controller.end_with?("student") && action == "create"
      is_create_admin   = controller.end_with?("org_admin") && action == "create"

      is_create_student || is_create_admin
    end

    def crud_on_controller?(controller_name, controller, action)
      controller.end_with?(controller_name) && action.in?(%w[create index show update destroy])
    end

    def reads_on_controller?(controller_name, controller, action)
      controller.end_with?(controller_name) && action.in?(%w[index show])
    end

    def my_course_section_updates_and_creates?(controller, action, params)
      if controller.end_with?("/course_section")
        is_updatable = (action == "update"  && @admin_courses.exists?(params[:course][:id]))
        is_deletable = (action == "destroy" && @admin_courses.exists?(CourseSection.find(params[:id]).course_id))
        is_creatable = (action == "create"  && @admin_courses.exists?(params[:course_id]))

        is_updatable || is_deletable || is_creatable
      else
        false
      end
    end

    def my_student_enrollment_cruds?(controller, action, params)
      if controller.end_with?("enrolled_course_section")
        is_deletable = (action == "destroy" && @admin_courses.exists?(CourseSection.find(params[:course_section_id]).course_id))
        is_creatable = (action == "create"  && @admin_courses.exists?(CourseSection.find(params[:course_section_id]).course_id))

        is_deletable || is_creatable
      else
        false
      end
    end

    def my_module_updates?(controller, action, params)
      controller.end_with?("learning_module") && action
        .in?(%w[update destroy]) && @admin_modules.exists?(params[:id])
    end

    def my_section_module_updates_and_creates?(controller, action, params)
      controller.end_with?("section_module") && action
        .in?(%w[update destroy create]) && @admin_courses
          .exists?(CourseSection.find(params[:course_section_id]).course_id)
    end

    def my_supplement_updates_and_creates?(controller, action, params)
      if controller.end_with?("module_supplement")
        is_updatable = (action.in?(%w[update create]) && @admin_modules.exists?(params[:learning_module_id]))
        is_deletable = (action == "destroy" && @admin_modules.exists?(ModuleSupplement
                                                                        .find(params[:id])
                                                                          .learning_module_id))
        is_deletable || is_updatable
      else
        false
      end
    end

    def admin_deliverable_or_content_updates_and_creates?(controller, action, params)
      if controller.end_with?("supplement_content") || controller
          .end_with?("deliverable") || controller.end_with?("content_upload") || controller
            .end_with?("wiki_content")
        supplement_id = params[:module_supplement] ? params[:module_supplement][:id] : params[:module_supplement_id]
        is_updatable = action == "update" && @admin_modules.exists?(ModuleSupplement
                                                                        .find(supplement_id)
                                                                          .learning_module_id)
        is_deletable = action == "destroy" && @admin_modules.exists?(SupplementContent
                                                                        .find(params[:id])
                                                                          .module_supplement
                                                                            .learning_module_id)
        is_creatable = action == "create" && @admin_modules.exists?(ModuleSupplement
                                                                      .find(supplement_id)
                                                                        .learning_module_id)
        is_updatable || is_deletable || is_creatable
      else
        false
      end
    end

    def student_submission_updatable?(controller, action, params)
      if action != "create" && (controller.end_with?("/submission") || controller
          .end_with?("submission_upload") || controller.end_with?("wiki_submission"))
        is_student_submission = Submission.find(params[:id]).student_id == @user.id

        is_updatable = action == "update"  && is_student_submission
        is_deletable = action == "destroy" && is_student_submission
        is_updatable || is_deletable
      else
        false
      end
    end

    def student_submission_creatable?(controller, action, params)
      if action == "create" && (controller.end_with?("/submission") || controller.end_with?("submission_upload") || controller
          .end_with?("wiki_submission"))
        deliverable_id = params[:deliverable] ? params[:deliverable][:id] : params[:deliverable_id]
        supplement_id  = Deliverable.find(deliverable_id).module_supplement_id

        @student_modules.exists?(ModuleSupplement.find(supplement_id).learning_module_id)
      else
        false
      end
    end

    def course_related_controller_request?(controller)
      related_controllers = %w[learning_module enrolled_course_section wiki_content
        content_upload /course_section section_module module_supplement
        deliverable supplement_content /submission submission_upload wiki_submission]

      related_controllers.any? { |related_controller| controller.end_with?(related_controller) }
    end

    def create_module_request?(controller, action, params)
      action == "create" && nested_org_request?(params[:organisation_id]) && controller
        .end_with?("learning_module")
    end

    def update_account_request?(controller, action, params)
      action == "update" && (controller.end_with?("org_admin") || controller
                             .end_with?("student")) && params[:id] == @user.id.to_s
    end

    def student_activity_request?(controller, action, params)
      action == "index" && controller.end_with?("activities") && params[:student_id] == @user.id.to_s
    end

    def organisation_students_request?(controller, params)
      controller.end_with?("student") && nested_org_request?(params[:organisation_id])
    end

    def section_students_request?(controller, params)
      params[:section_id] && controller.end_with?("student") && @org.has_section?(params[:section_id])
    end

    def organisation_student_request?(controller, params)
      controller.end_with?("student") && @org.students.exists?(params[:id])
    end

    def organisation_activity_request?(controller, params)
      controller.end_with?("activities") && nested_org_request?(params[:organisation_id])
    end

    def fellow_admins_request?(controller, params)
      controller.end_with?("org_admin") && nested_org_request?(params[:organisation_id])
    end

    def student_admins_request?(controller, action, params)
      fellow_admins_request?(controller, params) && action == "index" && user.id = params[:student_id]
    end

    def fellow_admin_request?(controller, params)
      controller.end_with?("org_admin") && @org.admins.exists?(params[:id])
    end

    def admin_is_owned?(controller, params)
      controller.end_with?("org_admin") && user.id == OrgAdmin.find(params[:id]).created_by.id
    end

    def student_is_owned?(controller, params)
      controller.end_with?("student") && user.id == Student.find(params[:id]).created_by.id
    end

    def student_self_request?(controller, params)
      controller.end_with?("student") && user.id.to_s == params[:id]
    end

    def students_owned?(controller, params)
      controller.end_with?("student") && user.id.to_s == params[:created_by]
    end
end
