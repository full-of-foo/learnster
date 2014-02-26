attributes :id, :section, :created_at, :updated_at, :provisioned_by, :course

node do |course_section|
    {
        student_count: course_section.students.count(),
        module_count: course_section.learning_modules.count(),
        created_at_formatted: course_section.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(course_section.updated_at())
    }
end

child :provisioned_by => :provisioned_by do
  attributes :id, :email, :first_name, :surname, :full_name, :type, :is_active
end

child :course => :course do
  attributes :id, :title, :organisation_id, :managed_by

  child :managed_by => :managed_by do
    attributes :id, :email, :first_name, :surname, :full_name
  end
end
