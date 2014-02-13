class PermittedParams < Struct.new(:params, :user)

  def user_params
    params.require(:student).permit(*user_attributes)
  end

  def org_admin_params
    params.require(:org_admin).permit(*user_attributes)
  end

  def sign_up_org_params
    params.require(:sign_up).permit(*sign_up_org_attributes)
  end

  def sign_up_admin_params
    params.require(:sign_up).permit(*sign_up_admin_attributes)
  end

  def org_params
    params.require(:organisation).permit(*org_attributes)
  end

  def course_params
    params.require(:course).permit(*course_attributes)
  end

  def course_section_params
    params.require(:course_section).permit(*course_section_attributes)
  end

  def section_module_params
    params.require(:section_module).permit(*section_module_attributes)
  end

  def learning_module_params
    params.require(:learning_module).permit(*learning_module_attributes)
  end

  def module_supplement_params
    params.require(:module_supplement).permit(*module_supplement_attributes)
  end

  def supplement_content_params
    params.require(:supplement_content).permit(*supplement_content_attributes)
  end

  private
    def user_attributes
      attrs = [:email, :first_name, :surname]
      if user.app_admin?
        attrs += [:created_by, :last_login, :is_active, :attending_org]
      elsif user.org_admin?
        attrs += [:created_by, :last_login, :is_active, :admin_for]
      end
      attrs
    end

    def sign_up_admin_attributes
      [:email, :first_name, :surname, :password, :password_confirmation]
    end

    def sign_up_org_attributes
      [:title, :description]
    end

    def org_attributes
        (user.app_admin? or user.org_admin?) ? [:title, :description]  : []
    end

    def course_attributes
      [:title, :description, :identifier]
    end

    def course_section_attributes
      [:course_id, :provisioned_by, :section]
    end

    def section_module_attributes
      [:course_section_id, :learning_module]
    end

    def learning_module_attributes
      [:organisation_id, :title, :description, :educator]
    end

    def module_supplement_attributes
      [:title, :description, :learning_module_id]
    end

    def supplement_content_attributes
      [:title, :description, :module_supplement, :file_upload]
    end

end
