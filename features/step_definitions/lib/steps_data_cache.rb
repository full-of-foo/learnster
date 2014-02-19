module StepsDataCache

  class << self
    attr_accessor :current_user
    attr_accessor :signup_user

    attr_accessor :organisation
    attr_accessor :signup_organisation
    attr_accessor :deleted_organisation
  end

end
