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
    attr_accessor :deleted_learning_module
    attr_accessor :supplement
    attr_accessor :wiki_content
    attr_accessor :deleted_wiki_content

    attr_accessor :deliverable
    attr_accessor :deleted_deliverable
    attr_accessor :wiki_submission
    attr_accessor :old_wiki_submission

    attr_accessor :student
    attr_accessor :deleted_student
    attr_accessor :admin
    attr_accessor :deleted_admin
  end

end
