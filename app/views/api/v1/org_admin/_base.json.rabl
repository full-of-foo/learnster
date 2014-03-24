attributes :id, :email, :first_name, :surname, :full_name, :role, :type, :confirmed, :confirmation_code,
 :is_active, :last_login, :created_at, :updated_at


node do |org_admin|
    {
        formatted_role: org_admin.role.split('_').map(&:capitalize).join(' '),
        last_login_formatted: time_ago_in_words(org_admin.last_login()),
        created_at_formatted: org_admin.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(org_admin.updated_at())
    }
end

child :admin_for => :admin_for do
  attributes :id, :title, :description
end

if root_object.respond_to?("created_by")
  child :created_by => :created_by do
    attributes :id, :email, :first_name, :surname, :full_name, :type
  end
end

