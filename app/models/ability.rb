class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new
      if user.type == "AppAdmin"
        can :manage, :all
      elsif user.type == "OrgAdmin"
        can [:update, :read], OrgAdmin, :id => user.id
        can [:read], OrgAdmin #change  - only fellow org_admins

        can [:read], Student #change  - only org students
        can [:update, :delete], Student, :created_by => { :id => user.id }

        can :manage, Organisation

      elsif user.type == "Student"
        can [:update, :read], Student, :id => user.id
      end

  end
end
