module Pages

  class ModulesPage < Pages::Page

    attr_accessor :title_field
    attr_accessor :description_field
    attr_accessor :update_title_field
    attr_accessor :update_description_field

    attr_accessor :create_module_button
    attr_accessor :update_module_button
    attr_accessor :create_supplement_button


    def initialize(browser)
      super(browser)
      @title_field                = @browser.text_field(name: 'title')
      @description_field          = @browser.text_field(name: 'description')
      @update_title_field         = @browser.text_field(id: 'title')
      @update_description_field   = @browser.text_field(id: 'description')

      @create_module_button     = @browser.button(id: 'Create Module')
      @update_module_button     = @browser.button(id: 'Update')
      @create_supplement_button = @browser.button(id: 'Create Supplement')
    end

    def submit_new_learning_module_form(learning_module)
      self.title_field.when_present.set(learning_module.title)
      self.description_field.set(learning_module.description)

      self.create_module_button.click
    end

    def submit_edit_module_form(title, description)
      self.update_title_field.when_present.set(title)
      self.update_description_field.set(description)

      self.update_module_button.click
    end

    def submit_new_supplement_form(supplement)
      self.title_field.when_present.set(supplement.title)
      self.description_field.set(supplement.description)

      self.create_supplement_button.click
    end

  end

end
