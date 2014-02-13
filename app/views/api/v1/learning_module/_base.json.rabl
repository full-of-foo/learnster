attributes :id, :title, :description, :created_at, :updated_at, :educator_id, :organisation_id


node do |learning_module|
    {
        shared_on_course_section_count: learning_module.shared_on_course_section_count(),
        supplement_count: learning_module.module_supplements.count(),
        created_at_formatted: learning_module.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(learning_module.updated_at())
    }
end

child :educator => :educator do
  attributes :id, :email, :first_name, :surname, :full_name, :type, :is_active
end

