class EnrolledCourseSection < ActiveRecord::Base
    belongs_to :student
    belongs_to :course_section

    validates_presence_of :student, :course_section
    validates_uniqueness_of :student, scope: :course_section,
      message: "student already enrolled"
    before_save :default_values


    protected
      def default_values
        self.is_active = true if self.is_active.nil?
      end

end
