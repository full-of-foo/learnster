module StepsDataCache
  class << self; attr_accessor :current_user_email          end
  class << self; attr_accessor :current_user_pass           end
  class << self; attr_accessor :organisation_description    end
  class << self; attr_accessor :organisation_title          end
end
