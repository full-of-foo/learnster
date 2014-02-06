module Pages

  class NotificationsPage < Pages::Page

    def initialize(browser)
      super(browser)
      @url = url("/#/login")
    end

    def visit
      @browser.goto @url
    end

  end

end
