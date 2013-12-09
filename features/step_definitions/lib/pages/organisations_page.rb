module Pages

  class OrganisationsPage < Pages::Page

    attr_accessor :add_organisation_link
    attr_accessor :close_well_button
    attr_accessor :title_field
    attr_accessor :description_field
    attr_accessor :add_organisation_button

    def initialize(browser)
      super(browser)
      @url = url("/#/organisaitons")

      @add_organisation_link    = @browser.link(id: 'new-org-button')
      @close_well_button        = @browser.button(class: 'close cancel-new-org')
      @title_field              = @browser.text_field(name: 'title')
      @description_field        = @browser.text_field(name: 'description')
      @add_organisation_button  = @browser.button(id: 'Add Organisation')
    end

    def visit 
      Log.debug(@url)
      Log.debug(@browser.inspect)
      @browser.goto @url
    end

    # operations

    def open_add_well
      @add_organisation_link.click
    end

    def close_add_well
      @close_well_button.click
    end

    def submit_new_organisation_form(title, description)
      self.title_field.set title
      self.description_field.set description
      self.add_organisation_button.click
      sleep 0.2
    end
    
  end
    
end
