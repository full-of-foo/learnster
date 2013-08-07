class PermittedUserParams < Struct.new(:params, :user)
  
  def user
    params.require(:topic).permit(*topic_attributes)
  end

  def user_attributes
    if user
      attrs = [:email, :first_name, :surname]
      if user.app_admin?
        attrs += [:last_login, :is_active]
      elsif user.org_admin?
        attrs += [:is_active]
      end
    end
  end

end