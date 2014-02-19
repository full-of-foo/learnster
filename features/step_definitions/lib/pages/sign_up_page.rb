module Pages

  class SignUpPage < Pages::Page
    attr_accessor :intro_next_link

    attr_accessor :first_name_field
    attr_accessor :surname_field
    attr_accessor :email_field
    attr_accessor :password_field
    attr_accessor :password_confirm_field

    attr_accessor :title_field
    attr_accessor :description_field

    attr_accessor :next_button
    attr_accessor :continue_button
    attr_accessor :pop_up_close_button
    attr_accessor :complete_button

    def initialize(browser)
      super(browser)
      @url = url("/#/signup")

      @intro_next_link = @browser.li(id: 'intro-next-link')

      @first_name_field = @browser.text_field(name: 'first_name')
      @surname_field = @browser.text_field(name: 'surname')
      @email_field = @browser.text_field(name: 'email')
      @password_field = @browser.text_field(name: 'password')
      @password_confirm_field = @browser.text_field(name: 'password_confirmation')

      @title_field = @browser.text_field(name: 'title')
      @description_field = @browser.text_field(name: 'description')

      @next_button = @browser.button(id: 'Next')
      @continue_button = @browser.button(id: 'Continue')
      @pop_up_close_button = @browser.button(class: 'btn btn-default')
      @complete_button = @browser.button(value: 'Complete Registration')
    end

    def visit
      @browser.goto @url
    end

    def click_continue_link
      @intro_next_link.when_present.click
    end

    def sign_up_account_admin(user)
      self.first_name_field.set(user.first_name)
      self.surname_field.set(user.surname)
      self.email_field.set(user.email)
      self.password_field.set(user.password)
      self.password_confirm_field.set(user.password)

      self.next_button.click
    end

    def confirm_signup(user)
      self.pop_up_close_button.click
      self.email_field.set(user.email)
      self.password_field.set(user.password)

      self.continue_button.click
    end

    def sign_up_organisation(organisation)
      self.title_field.set(organisation.title)
      self.description_field.set(organisation.description)

      self.complete_button.click
    end

  end

end
