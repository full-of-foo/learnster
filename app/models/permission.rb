class Permission < Struct.new(:user)

  def allow?(controller, action, params)
    return true if controller.end_with?("sessions")
    return true if controller.end_with?("application") && action == "index"
    if user
      return true if user.app_admin?
      if user.org_admin?
        # TODO - tidy
        @org = user.admin_for

        return true if controller.end_with?("student") && action == "create"
        return true if controller.end_with?("org_admin") && action == "create"
        return true if organisation_request?(controller, params) && action.in?(%w[show edit])

        if action.in?(%w[index show])
          return true if organisation_students_request?(controller, params)
          return true if fellow_admins_request?(controller, params)
          return true if organisation_activity_request?(controller, params)
          return true if students_owned?(controller, params)
        end

        if action.in?(%w[update destroy])
          return true if student_is_owned?(controller, params)
          return true if admin_is_owned?(controller, params)
        end

        if action.in?(%w[show edit])
          return true if fellow_admin_request?(controller, params)
          return true if organisation_student_request?(controller, params)
        end

        # TODO - wrap in condition - test whether org_id in param
        if user.role.account_manager?
          return true if controller.end_with?("student") && action == "import"
          return true if controller.end_with?("org_admin") && action == "import"
          return true if controller.end_with?("course") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("learning_module") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("course_section") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("section_module") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("module_supplement") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("supplement_content") && action.in?(%w[create index show edit update destroy])
          return true if section_students_request?(controller, params) && action.in?(%w[index])
        end

        if user.role.course_manager?
          return true if controller.end_with?("course") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("learning_module") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("course_section") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("section_module") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("module_supplement") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("supplement_content") && action.in?(%w[create index show edit update destroy])
          return true if section_students_request?(controller, params) && action.in?(%w[index])
        end

        if user.role.module_manager?
          return true if controller.end_with?("learning_module") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("section_module") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("module_supplement") && action.in?(%w[create index show edit update destroy])
          return true if controller.end_with?("supplement_content") && action.in?(%w[create index show edit update destroy])
          return true if section_students_request?(controller, params) && action.in?(%w[index])
        end

      end
      if user.student?
        @org = user.attending_org

        return true if organisation_request?(controller, params) && action == "show"

        if action.in?(%w[index show])
          return true if organisation_students_request?(controller, params)
        end
        #TODO - implement
      end
    end
    false
  end


  private

    def organisation_request?(controller, params)
      controller.end_with?("organisation") && params[:id].to_i == @org.id
    end


    def organisation_students_request?(controller, params)
      controller.end_with?("student") && params[:organisation_id].to_i == @org.id
    end

    def section_students_request?(controller, params)
      params[:section_id] && controller.end_with?("student") && @org.has_section?(params[:section_id])
    end

    def organisation_student_request?(controller, params)
      controller.end_with?("student") && @org.students.exists?(params[:id])
    end

    def organisation_activity_request?(controller, params)
      controller.end_with?("activities") && params[:organisation_id].to_i == @org.id
    end

    def fellow_admins_request?(controller, params)
      controller.end_with?("org_admin") && params[:organisation_id].to_i == @org.id
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

    def students_owned?(controller, params)
      controller.end_with?("student") && user.id.to_s == params[:created_by]
    end
end
