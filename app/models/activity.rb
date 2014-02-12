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

end
