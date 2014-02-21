module Pages

  class SideNav < Pages::Page
    attr_accessor :sign_in_nav_link
    attr_accessor :sign_up_nav_link

    attr_accessor :orgs_nav_link
    attr_accessor :app_admins_nav_link
    attr_accessor :app_students_nav_link

    attr_accessor :dash_nav_link
    attr_accessor :all_admins_nav_link
    attr_accessor :all_students_nav_link
    attr_accessor :my_admins_nav_link
    attr_accessor :my_students_nav_link


    def initialize(browser)
      super(browser)

      @sign_in_nav_link     = @browser.link(id: 'side-item-sign-in')
      @sign_up_nav_link     = @browser.link(id: 'side-item-sign-up')

      @orgs_nav_link        = @browser.link(id: 'side-item-orgs')
      @app_admins_nav_link  = @browser.link(id: 'side-item-app-admins')
      @app_students_nav_link = @browser.link(id: 'side-item-app-students')

      @dash_nav_link          = @browser.link(id: 'side-item-dash')
      @all_admins_nav_link    = @browser.link(id: 'side-item-all-admins')
      @all_students_nav_link  = @browser.link(id: 'side-item-all-students')
      @my_admins_nav_link    = @browser.link(id: 'side-item-my-administrators')
      @my_students_nav_link  = @browser.link(id: 'side-item-my-students')
    end

    # operations
    def side_nav_to(link)
      link.when_present.click
    end

  end

end
