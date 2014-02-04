module Pages

  class SideNav < Pages::Page
    attr_accessor :sign_in_nav_link
    attr_accessor :sign_up_nav_link

    def initialize(browser)
      super(browser)

      @sign_in_nav_link = @browser.link(id: 'side-item-sign-in')
      @sign_up_nav_link = @browser.link(id: 'side-item-sign-up')
    end

    # operations
    def side_nav_to(link)
      link.when_present.click
    end

  end

end
