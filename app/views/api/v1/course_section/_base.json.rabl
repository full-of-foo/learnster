attributes :id, :section, :created_at, :updated_at, :provisioned_by, :course_id


node do |course_section|
    {
        created_at_formatted: course_section.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(course_section.updated_at())
    }
end

child :provisioned_by => :provisioned_by do
  attributes :id, :email, :first_name, :surname, :full_name, :type, :is_active
end
