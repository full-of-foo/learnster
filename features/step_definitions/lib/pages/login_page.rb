module Pages

  class LoginPage < Pages::Page

    attr_accessor :email_field
    attr_accessor :password_field
    attr_accessor :login_button

    URLS = { :development => "http://localhost:3000/#/login" }

    def initialize(browser)
      super(browser)
      @url = URLS[:development]

      @email_field    = @browser.text_field(name: 'email')
      @password_field = @browser.text_field(name: 'password')
      @login_button   = @browser.button(text: 'Login')
    end

    def visit
      @browser.goto @url
    end

    # operations
    def attempt_login(email, password)
      self.email_field.set email
      self.password_field.set password
      self.login_button.click
    end
    
  end
  
end
