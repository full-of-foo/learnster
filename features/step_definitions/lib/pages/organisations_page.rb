module Pages

  class OrganisationsPage < Pages::Page

    attr_accessor :add_organisation_link
    attr_accessor :close_well_button
    attr_accessor :title_field
    attr_accessor :description_field
    attr_accessor :add_organisation_button

    attr_accessor :search_term_field
    attr_accessor :search_button


    def initialize(browser)
      super(browser)
      @url = url("/#/organisations")

      @add_organisation_link    = @browser.link(id: 'new-org-button')
      @close_well_button        = @browser.button(class: 'close cancel-new-org')
      @title_field              = @browser.text_field(name: 'title')
      @description_field        = @browser.text_field(name: 'description')
      @add_organisation_button  = @browser.button(id: 'Add Organisation')

      @search_term_field        = @browser.text_field(id: 'search')
      @search_button            = @browser.button(text: 'Search')
    end

    def visit 
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

    def search_organisations_grid(search_term)
      self.search_term_field.set search_term
      self.search_button.click
      sleep 0.2
    end
    
  end
    
end
