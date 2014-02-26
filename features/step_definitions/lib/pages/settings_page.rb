module Pages

  class SettingsPage < Pages::Page
    attr_accessor :first_name_field
    attr_accessor :surname_field
    attr_accessor :email_field
    attr_accessor :password_field
    attr_accessor :password_confirm_field

    attr_accessor :update_button


    def initialize(browser)
      super(browser)

      @first_name_field       = @browser.text_field(id: 'first_name')
      @surname_field          = @browser.text_field(id: 'surname')
      @email_field            = @browser.text_field(id: 'email')
      @password_field         = @browser.text_field(id: 'password')
      @password_confirm_field = @browser.text_field(id: 'password_confirmation')

      @update_button          = @browser.button(id: 'Update')
    end

    def submit_settings_form(new_first_name, new_surname)
      self.first_name_field.when_present.set(new_first_name)
      self.surname_field.set(new_surname)

      self.update_button.click
    end

  end

end
