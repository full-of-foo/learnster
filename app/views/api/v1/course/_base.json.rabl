attributes :id, :title, :description, :created_at, :updated_at, :managed_by


node do |course|
    {
        created_at_formatted: course.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(course.updated_at()),
        sectionCount: course.course_sections.count()
    }
end

child :managed_by => :managed_by do
  attributes :id, :email, :first_name, :surname, :full_name, :type, :is_active
end

