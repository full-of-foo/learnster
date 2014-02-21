module Pages

  class AdminsPage < Pages::Page
    attr_accessor :first_name_field
    attr_accessor :surname_field
    attr_accessor :email_field
    attr_accessor :password_field
    attr_accessor :password_confirm_field
    attr_accessor :add_button
    attr_accessor :update_button


    def initialize(browser)
      super(browser)

      @first_name_field       = @browser.text_field(id: 'first_name')
      @surname_field          = @browser.text_field(id: 'surname')
      @email_field            = @browser.text_field(id: 'email')
      @password_field         = @browser.text_field(id: 'password')
      @password_confirm_field = @browser.text_field(id: 'password_confirmation')
      @add_button             = @browser.button(id: 'Add Admin')
      @update_button          = @browser.button(id: 'Update')
    end

    def submit_new_admin_form(admin)
      self.first_name_field.when_present.set(admin.first_name)
      self.surname_field.set(admin.surname)
      self.email_field.set(admin.email)
      self.password_field.set(admin.password)
      self.password_confirm_field.set(admin.password)

      self.add_button.click
    end

    def submit_edit_admin_form(new_first_name, new_email, password)
      self.first_name_field.when_present.set(new_first_name)
      self.email_field.set(new_email)
      self.password_field.set(password)
      self.password_confirm_field.set(password)

      self.update_button.click
    end

  end

end
