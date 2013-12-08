module Pages

  class HeaderNav < Pages::Page
    attr_accessor :logout_button

    def initialize(browser)
      super(browser)

      @logout_button = @browser.div(id: 'destroy-session-icon')
    end

    # operations
    def attempt_logout
      self.logout_button.click
    end
    
  end

end
