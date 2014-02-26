module Pages

  class TopNav < Pages::Page
    attr_accessor :notifications_nav_link
    attr_accessor :home_nav_link
    attr_accessor :stats_nav_link
    attr_accessor :settings_nav_link

    attr_accessor :about_nav_link
    attr_accessor :testimonials_nav_link
    attr_accessor :join_nav_link

    def initialize(browser)
      super(browser)

      @home_nav_link          = @browser.li(id: 'home-dock-item')
      @notifications_nav_link = @browser.li(id: 'notifications-dock-item')
      @stats_nav_link         = @browser.li(id: 'stats-dock-item')
      @settings_nav_link         = @browser.li(id: 'profile-settings-dock-item')

      @about_nav_link         = @browser.li(id: 'about-dock-item')
      @testimonials_nav_link  = @browser.li(id: 'testimonials-dock-item')
      @join_nav_link          = @browser.li(id: 'join-dock-item')
    end

    # operations
    def top_nav_to(link)
      link.when_present.click
    end

  end

end
