module StepsDataCache

  class << self
    attr_accessor :current_user
    attr_accessor :signup_user

    attr_accessor :organisation
    attr_accessor :signup_organisation
    attr_accessor :deleted_organisation

    attr_accessor :course
    attr_accessor :deleted_course
    attr_accessor :course_section

    attr_accessor :learning_module

    attr_accessor :student
  end

end
