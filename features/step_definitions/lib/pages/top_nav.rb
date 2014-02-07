module Pages

  class TopNav < Pages::Page
    attr_accessor :notifications_nav_link
    attr_accessor :home_nav_link
    attr_accessor :stats_nav_link

    def initialize(browser)
      super(browser)

      @home_nav_link = @browser.li(id: 'home-dock-item')
      @notifications_nav_link = @browser.li(id: 'notifications-dock-item')
      @stats_nav_link = @browser.li(id: 'stats-dock-item')
    end

    # operations
    def top_nav_to(link)
      link.when_present.click
    end

  end

end