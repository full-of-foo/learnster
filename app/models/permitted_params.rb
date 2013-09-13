class PermittedParams < Struct.new(:params, :user)
  
  def user_params
    params.require(:student).permit(*user_attributes)
  end

  def org_params
    params.require(:organisation).permit(*org_attributes)
  end

  def user_attributes
    attrs = [:email, :first_name, :surname]
    if user.app_admin?
      attrs += [:last_login, :is_active, :created_by, :attending_org]
    elsif user.org_admin?
      attrs += [:is_active, :created_by, :attending_org]
    end
    attrs
  end

   def org_attributes
      (user.app_admin? or user.org_admin?) ? [:title, :description]  : []
  end

end