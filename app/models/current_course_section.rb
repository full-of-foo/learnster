class CurrentCourseSection < ActiveRecord::Base
    has_one :student
    has_one :course_section
end
