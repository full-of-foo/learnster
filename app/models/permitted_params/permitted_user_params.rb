class PermittedUserParams < Struct.new(:params, :user)
  
  def user
    params.require(:topic).permit(*user_attributes)
  end

  def user_attributes
    if user
      attrs = [:email, :first_name, :surname, :created_by]
      if user.app_admin?
        attrs += [:last_login, :is_active, :admin_for, :created_by]
      elsif user.org_admin?
        attrs += [:is_active, :admin_for, :created_by]
      end
    end
  end

end