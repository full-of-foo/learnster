class PermittedParams < Struct.new(:params, :user)

  def user_params
    params.require(:student).permit(*user_attributes)
  end

  def org_admin_params
    params.require(:org_admin).permit(*user_attributes)
  end

  def sign_up_params
    params.require(:sign_up).permit(*sign_up_attributes)
  end

  def org_params
    params.require(:organisation).permit(*org_attributes)
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

    def sign_up_attributes
      [:email, :first_name, :surname, :password, :password_confirmation]
    end

    def org_attributes
        (user.app_admin? or user.org_admin?) ? [:title, :description]  : []
    end

end
