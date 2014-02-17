attributes :id, :student_id, :course_section_id

node do |enrolled_course_section|
    {
        created_at_formatted: enrolled_course_section.created_at.strftime("%d/%m/%Y"),
        updated_at_formatted: time_ago_in_words(enrolled_course_section.updated_at())
    }
end

