module Pages

  class SignUpPage < Pages::Page

    def initialize(browser)
      super(browser)
      @url = url("/#/signup")

    end

    def visit
      @browser.goto @url
    end

  end

end
